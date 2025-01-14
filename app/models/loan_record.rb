class LoanRecord < ApplicationRecord
  validates :account, presence: true, uniqueness: true
  validates :data, presence: true
end
