class Transaction < ApplicationRecord
  # As there can be many transactions we delete it by a single sql command 
  # assuming there are no callbacks needed
  belongs_to :merchant, inverse_of: :transactions
end
