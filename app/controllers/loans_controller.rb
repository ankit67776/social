class LoansController < ApplicationController
  require "net/http"
  require "json"

  BASE_URL = "https://absws.com/TmoAPI/v1/LSS.svc"

  def loan_portfolio
    response = fetch_api_data("#{BASE_URL}/GetLoans")

    unless response.is_a?(Hash) && response["Data"].is_a?(Array)
      Rails.logger.error("Unexpected API response format: #{response}")
      return render_error("Invalid loan data received from API")
    end
    loans = response["Data"]

    # Fetch individual loan details
    loan_details = loans.map do |loan|
      loan_detail_response = fetch_api_data("#{BASE_URL}/GetLoan/#{loan['Account']}")
      loan_detail_response["Data"] if loan_detail_response
    end.compact

    # Calculate loan insights based on detailed loan data
    total_loans = loan_details.size
    status_distribution = loan_details.each_with_object(Hash.new(0)) do |loan, counts|
      counts[loan["Status"]] += 1
    end

    total_loan_amount = loan_details.sum { |loan| loan["Terms"]["OrigBal"].to_f }
    average_loan_amount = total_loans.positive? ? (total_loan_amount / total_loans).round(2) : 0
    largest_loan = loan_details.max_by { |loan| loan["Terms"]["OrigBal"].to_f }&.dig("Terms", "OrigBal") || 0
    smallest_loan = loan_details.min_by { |loan| loan["Terms"]["OrigBal"].to_f }&.dig("Terms", "OrigBal") || 0

    # Response data
    @insights = {
      total_loans: total_loans,
      status_distribution: status_distribution,
      total_loan_amount: total_loan_amount,
      average_loan_amount: average_loan_amount,
      largest_loan: largest_loan,
      smallest_loan: smallest_loan
    }

    render :loan_portfolio
  end

  private

  def fetch_api_data(url)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request["Token"] = "ABS"
    request["Database"] = "World Mortgage Company"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    Rails.logger.info("Response from #{url}: #{response.body}")
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body) rescue nil
    else
      Rails.logger.error("Failed to fetch data from #{url}: #{response.code} - #{response.message}")
      nil
    end
  end

  def render_error(message)
    render json: { error: message }, status: :bad_request
  end
end
