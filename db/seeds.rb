# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

# customers
10.times do
  Customer.create!(
    name: Faker::Name.name,
    details: Faker::Lorem.sentence
  )
end

# seed loan applications
Customer.all.each do |customer|
  2.times do
    loan_application= LoanApplication.create!(
      customer: customer,
      creation_date: Faker::Date.backward(days: 365),
      application_details: Faker::Lorem.paragraph
    )

    # seed loans for each loan application
    3.times do
      Loan.create!(
        customer: customer,
        loan_application: loan_application,
        details: "Loan approved for #{Faker::Number.decimal(l_digits: 5, r_digits: 2)} USD"
      )
    end
  end
end

# properties for each loan
Loan.all.each do |loan|
  Property.create!(
    loan: loan,
    details: Faker::Lorem.sentence
  )
end

# construction draws for each loan
Loan.all.each do |loan|
  ConstructionDraw.create!(
    loan: loan,
    customer: loan.customer,
    details: Faker::Lorem.paragraph
  )
end

# construction progress for each property
Property.all.each do |property|
  ConstructionProgress.create!(
    property: property,
    details: Faker::Lorem.paragraph
  )
end

# seed payments for each loan
Loan.all.each do |loan|
  5.times do
    Payment.create!(
      loan: loan,
      details: "Payment of  #{Faker::Number.decimal(l_digits: 4, r_digits: 2)} USD"
    )
  end
end

# payment schedules for each loan
Loan.all.each do |loan|
  PaymentSchedule.create!(
    loan: loan,
    details: Faker::Lorem.sentence
  )
end

puts "Data created successfully"
