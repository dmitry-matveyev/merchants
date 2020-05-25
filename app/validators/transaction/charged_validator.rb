class Transaction < ApplicationRecord
    class ChargedValidator < Validator
      def call
        result = super
        return result unless result.success?

        return invalid_result(transaction_id: 'invalid') unless authorized_transaction_exists?

        valid_result({})
      end

      private

      def authorized_transaction_exists?
        merchant = params[:merchant]
        amount = params[:amount]
        transaction_id = params[:transaction_id] 

        merchant.transactions.authorized.approved.
          where(id: transaction_id, amount: amount).exists?
      end
    end
end

