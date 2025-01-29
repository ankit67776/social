class GetbuiltProperty < ApplicationRecord
  validates :account, presence: true, uniqueness: true
end
