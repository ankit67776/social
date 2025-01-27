# app/controllers/loans_controller.rb
class LoansController < ApplicationController
  def index
    @loans = Loan.all.map do |loan|
      loan_data = loan.data.is_a?(String) ? JSON.parse(loan.data) : loan.data
      loan.data = loan_data # Ensure parsed data is assigned to the loan object
      loan
    end
  end

  def show
    @loan = Loan.find(params[:id])
    @loan.data = JSON.parse(@loan.data) # Parse the JSON data for show view
  end
end
