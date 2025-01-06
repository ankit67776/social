class Property < ApplicationRecord
  belongs_to :loan
  has_one :construction_progress
end
