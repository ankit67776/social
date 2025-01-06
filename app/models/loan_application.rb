class LoanApplication < ApplicationRecord
  belongs_to :customer
  has_one :loan
  validates :creation_date, presence: true
end
