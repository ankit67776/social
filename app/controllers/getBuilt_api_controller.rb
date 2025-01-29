# app/controllers/api_responses_controller.rb
class GetbuiltPropertyController < ApplicationController
  before_action :authenticate

  private

  def authenticate
    provided_token = request.headers["Authorization"]
    valid_token = Rails.application.credentials.dig(:api, :auth_token)

    render json: { error: "Unauthorized" }, status: :unauthorized unless provided_token == "Bearer #{valid_token}"
  end


  def fetch_and_save
    ApiDataService.fetch_and_store
    render json: { message: "Data fetched and saved successfully" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
