class Transaction < ApplicationRecord
  # As there can be many transactions we delete it by a single sql command 
  # assuming there are no callbacks needed
  belongs_to :merchant, inverse_of: :transactions

  enum status: {approved: 0, reversed: 1, refunded: 2, error: 4}

  scope :authorized, -> { where(type: Transaction::Authorized.to_s) }

  validates :merchant, presence: true
  validates :uuid,  presence: true
  validates :type, presence: true
  validates :status, presence: true
end
