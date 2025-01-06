class Loan < ApplicationRecord
  belongs_to :customer
  belongs_to :loan_application
  has_one :property
  has_many :payments
  has_one :payment_schedules
  has_many :construction_draws
end
