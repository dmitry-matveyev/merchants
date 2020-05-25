class Transaction < ApplicationRecord
  # TODO: consider better place for this service
  class SaveService < BaseService

    def call
      resource = scope.new(
        amount: amount,
        uuid: generate_uuid,
        parent_id: parent_id
      )

      return valid_result(uuid: resource.uuid) if resource.save

      invalid_result(resource.errors)
    end

    private

    def initialize(params)
      self.scope = params[:scope]
      self.amount = params[:amount]
      self.parent_id = params[:parent_id]
    end

    def generate_uuid
      SecureRandom.uuid
    end

    attr_accessor :scope, :amount, :parent_id
  end
end

