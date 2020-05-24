class Transaction < ApplicationRecord
  # As there can be many transactions we delete it by a single sql command 
  # assuming there are no callbacks needed
  belongs_to :merchant, inverse_of: :transactions

  # TODO: make status values more verbose
  enum status: {approved: 0, reversed: 1, refunded: 2, error: 4}

  %i[authorized charged].each do |scope_name|
    scope scope_name, -> { where(type: Transaction.const_get(scope_name.to_s.capitalize).name) }
  end

  # Here is basic data validations which should match db internal validations
  # that's the reason they are here in model
  validates :merchant, presence: true
  validates :uuid,  presence: true
  validates :type, presence: true
  validates :status, presence: true
end
