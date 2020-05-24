class Transaction < ApplicationRecord
  class CreateService < BaseService
    # Do not pass user params directly into send method
    # even if it is validated
    # to decouple param name from method name
    SCOPES = {authorize: :authorized, charge: :charged}.with_indifferent_access
    VALIDATORS = %i[charged]

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

      resource = scope.new(
        amount: amount,
        uuid: generate_uuid,
      )

      return valid_result(uuid: resource.uuid) if resource.save

      invalid_result(resource.errors)
    end

    private

    def initialize(params)
      self.merchant = params[:merchant]
      self.amount = params[:amount]
      self.type = SCOPES[params[:type]]
      self.transaction_id = params[:transaction_id]
    end

    def generate_uuid
      SecureRandom.uuid
    end

    def scope
      merchant.transactions.approved.public_send(type)
    end

    def validator_class
      scope_name = type.in?(VALIDATORS) ? type : nil
      class_name = :"#{scope_name.to_s.capitalize}Validator"
      Transaction.const_get(class_name)
    end

    attr_accessor :merchant, :amount, :type, :transaction_id
  end
end

