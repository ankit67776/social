# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Sample data for Loans and LoanHistories
loans_data = [
  { account: "1000", categories: "Personal Loan", orig_bal: 200000, data: { "key" => "value" } },
  { account: "1001", categories: "Car Loan", orig_bal: 15000, data: { "key" => "value" } },
  { account: "1002", categories: "Mortgage", orig_bal: 300000, data: { "key" => "value" } },
  { account: "1003", categories: "Personal Loan", orig_bal: 25000, data: { "key" => "value" } },
  { account: "1004", categories: "Car Loan", orig_bal: 18000, data: { "key" => "value" } },
  { account: "1005", categories: "Home Equity", orig_bal: 50000, data: { "key" => "value" } },
  { account: "1006", categories: "Mortgage", orig_bal: 220000, data: { "key" => "value" } },
  { account: "1007", categories: "Student Loan", orig_bal: 8000, data: { "key" => "value" } },
  { account: "1008", categories: "Personal Loan", orig_bal: 15000, data: { "key" => "value" } },
  { account: "1009", categories: "Car Loan", orig_bal: 25000, data: { "key" => "value" } }
]

loans_data.each do |loan_data|
  loan = Loan.find_or_initialize_by(account: loan_data[:account])
  loan.update!(data: loan_data[:data], orig_bal: loan_data[:orig_bal], categories: loan_data[:categories])

  # Generate LoanHistory data for each loan
  loan_history_data = [
    {
      "loan_balance" => loan_data[:orig_bal],
      "notes" => "Initial funding from loan #{loan_data[:account]}",
      "paid_to" => "2/15/2010",
      "source_app" => "TDS-FUNDING",
      "total_amount" => -loan_data[:orig_bal]
    }
  ]

  loan_history_data.each do |history|
    loan.loan_histories.create!(
      loan_balance: history["loan_balance"],
      notes: history["notes"],
      paid_to: history["paid_to"],
      source_app: history["source_app"],
      total_amount: history["total_amount"]
    )
  end
end
