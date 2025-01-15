class Loan < ApplicationRecord
  has_many :loan_histories, dependent: :destroy
end
