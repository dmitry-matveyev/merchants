class Merchant < ApplicationRecord
  enum status: { active: 1, inactive: 0 }

  # As there can be many transactions we delete it by a single sql command
  # assuming there are no callbacks needed
  has_many :transactions, inverse_of: :merchant, dependent: :delete_all
end
