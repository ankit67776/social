# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

customer = Customer.find(1)

if customer
  # Create a loan application for this customer
  loan_application = LoanApplication.find_or_create_by(
    customer: customer,
    creation_date: Date.today,
    application_details: "Loan application for property purchase"
  )

  # Create multiple loans for the customer
  Loan.create!(
    customer: customer,
    loan_application: loan_application,
    details: "Loan approved for $200,000"
  )

  puts "Loans created successfully for #{customer.name}"
else
  puts "Customer not found"
end
