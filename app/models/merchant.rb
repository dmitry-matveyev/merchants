class Merchant < ApplicationRecord
  enum status: { active: 1, inactive: 0 }
  has_many :transactions, inverse_of: :merchant, dependent: :delete_all
end
