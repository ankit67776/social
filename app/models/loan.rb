class Loan < ApplicationRecord
  belongs_to :customer
  belongs_to :loan_application

  validates :account, presence: true
  validates :categories, presence: true
  validates :orig_bal, numericality: true
end
