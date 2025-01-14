class LoansController < ApplicationController
  require "net/http"
  require "json"

  BASE_URL = "https://absws.com/TmoAPI/v1/LSS.svc"

  def fetch_and_store_loans
    response = fetch_api_data("#{BASE_URL}/GetLoans")

    if response.is_a?(Hash) && response["Data"].is_a?(Array)
      response["Data"].each do |loan_data|
        Loan.find_or_initialize_by(account: loan_data["Account"]).update(
          categories: loan_data["Categories"],
          orig_bal: loan_data.dig("Terms", "OrigBal"),
          data: loan_data # Store the entire API response in JSON format
        )
      end

      render json: { message: "Loans successfully stored in the database" }, status: :ok
    else
      Rails.logger.error("Unexpected API response format: #{response}")
      render json: { error: "Invalid Response" }, status: :bad_request
    end
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
