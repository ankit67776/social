class PropertiesController < ApplicationController
  def loan_overview
    @property = GetbuiltProperty.find_by(id: params[:id])
    if @property
      @loan_data = @property.data
    else
      render json: { error: "Loan not found" }, status: :not_found
    end
  end

  def loan_analytics
    @property = GetbuiltProperty.find_by(id: params[:id])
    if @property
      financials = @property.data.dig("financials")
      @analytics_data = {
        available_construction: financials["amountAvailableForConstruction"],
        equity_remaining: financials["equityRemaining"],
        funds_drawn: financials["drawnToDate"],
        retainage_amount: financials["retainageAmount"]
      }
    else
      render json: { error: "Loan not found" }, status: :not_found
    end
  end
end
