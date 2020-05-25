class Transaction < ApplicationRecord
  class CreateService < BaseService
    # Do not pass user params directly into send method
    # even if it is validated
    # to decouple param name from method name
    SCOPES = {authorize: :authorized, charge: :charged, refund: :refunded}.with_indifferent_access
    VALIDATORS = %i[charged refunded]

    def call
      # TODO: we can use ActiveModel::Validations or Dry::Monads
      # it is ok to keep in plain ruby 'till it is simple
      result = validator_class.call(
        merchant: merchant,
        type: type,
        amount: amount,
        transaction_id: transaction_id        
      )
      return invalid_result(result.errors) unless result.success?

      save_service_class.call(scope: scope, amount: amount, parent_id: transaction_id)
    end

    private

    def initialize(params)
      self.merchant = params[:merchant]
      self.amount = params[:amount]
      self.type = SCOPES[params[:type]]
      self.transaction_id = params[:transaction_id]
    end

    def scope
      merchant.transactions.approved.public_send(type)
    end

    def validator_class
      scope_name = type.in?(VALIDATORS) ? type : nil
      class_name = :"#{scope_name.to_s.capitalize}Validator"
      Transaction.const_get(class_name)
    end

    def save_service_class
      service_name = 'SaveService'
      transaction_class = Transaction.const_get(type.to_s.classify)
      if transaction_class.const_defined?(service_name)
        transaction_class.const_get(service_name)
      else
        service_name.constantize
      end
    end

    attr_accessor :merchant, :amount, :type, :transaction_id
  end
end

