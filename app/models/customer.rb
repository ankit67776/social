class Customer < ApplicationRecord
  has_many :loan_applications
  has_many :loans
  has_many :construction_draws
  validates :name, presence: true, length: { maximum: 50 }
end
