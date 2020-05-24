class Transaction < ApplicationRecord
  class CreateService < BaseService
    INITIAL_STATUS = :approved
    # Do not pass user params directly into send method
    # even if it is validated
    # to decouple param name from method name
    SCOPES = {authorize: :authorized, charge: :charged}.with_indifferent_access

    def call
      # TODO: we can use ActiveModel::Validations or Dry::Monads
      # it is ok to keep in plain ruby 'till it is simple
      return invalid_result(errors) unless valid?

      resource = scope.new(
        amount: amount,
        uuid: generate_uuid,
        status: INITIAL_STATUS
      )

      return valid_result(uuid: resource.uuid) if resource.save

      invalid_result(resource.errors)
    end

    private

    def initialize(params)
      self.merchant = params[:merchant]
      self.amount = params[:amount]
      self.type = params[:type]
      self.errors = {}
    end

    def generate_uuid
      SecureRandom.uuid
    end

    def scope
      scope_name = SCOPES[type]
      merchant.transactions.public_send(scope_name)
    end

    def valid?
      errors[:type] = 'invalid' if SCOPES[type].blank?
      errors.empty?
    end

    attr_accessor :merchant, :amount, :type, :errors
  end
end

