class LoansController < ApplicationController
  require "net/http"
  require "json"

  BASE_URL = "https://absws.com/TmoAPI/v1/LSS.svc"

  def fetch_and_store_loans_with_history
    loans_response = fetch_api_data("#{BASE_URL}/GetLoans")

    if loans_response.nil? || !loans_response["Data"].is_a?(Array)
      Rails.logger.error("Failed to fetch loans or invalid response format: #{loans_response}")
      render json: { error: "Failed to fetch loans or invalid response format" }, status: :bad_request
      return
    end

    successful_accounts = []
    failed_accounts = []

    loans_response["Data"].each do |loan_data|
      begin
        account = loan_data["Account"]
        loan_history_response = fetch_api_data("#{BASE_URL}/GetLoanHistory/#{account}")

        if loan_history_response.nil? || !loan_history_response["Data"].is_a?(Array)
          Rails.logger.error("Failed to fetch valid loan history for account #{account}")
          failed_accounts << account
          next
        end

        Loan.find_or_initialize_by(account: account).tap do |loan|
          # Only save loan data and loan history
          loan.loan_history = loan_history_response
          loan.data = loan_data
          loan.save!
        end

        successful_accounts << account
      rescue => e
        Rails.logger.error("Error processing loan for account #{loan_data['Account']}: #{e.message}")
        failed_accounts << account
      end
    end

    render json: {
      message: "Loans processed",
      successful_accounts: successful_accounts,
      failed_accounts: failed_accounts
    }, status: :ok
  end

  private

  def fetch_api_data(url)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request["Token"] = ENV.fetch("API_TOKEN", "ABS")
    request["Database"] = ENV.fetch("API_DATABASE", "World Mortgage Company")

    begin
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
    rescue StandardError => e
      Rails.logger.error("Failed to fetch data from #{url}: #{e.message}")
      return nil
    end

    Rails.logger.info("Response from #{url}: #{response.body}")

    if response.is_a?(Net::HTTPSuccess)
      begin
        JSON.parse(response.body)
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse JSON response: #{e.message}")
        nil
      end
    else
      Rails.logger.error("Failed to fetch data from #{url}: #{response.code} - #{response.message}")
      nil
    end
  end
end
