class Transaction < ApplicationRecord
  class Validator < BaseValidator
    VALID_TYPES = %w(authorized charged refunded)

    def call
      return invalid_result(type: 'invalid') unless params[:type].to_s.in?(VALID_TYPES)

      valid_result({})
    end
  end
end

