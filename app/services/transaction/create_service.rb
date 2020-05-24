class Transaction < ApplicationRecord
  class CreateService < BaseService
    INITIAL_STATUS = :approved

    def call
      transaction = merchant.transactions.authorized.create!(
        amount: amount,
        uuid: generate_uuid,
        status: INITIAL_STATUS
      )
      transaction.uuid
    end

    private

    def initialize(params)
      self.merchant = params[:merchant]
      self.amount = params[:amount]
    end

    def generate_uuid
      SecureRandom.uuid
    end

    attr_accessor :merchant, :amount
  end
end

