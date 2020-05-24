module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_merchant

      def create
        result = Transaction::CreateService.call(permit_params.merge(merchant: @merchant))

        response_params = if result.success?
          render json: { uuid: result.uuid }
        else
          render json: { errors: result.errors }, status: 422
        end
      end

      private

      def permit_params
        params.permit(:amount, :type, :transaction_id)
      end

      def set_merchant
        # TODO: must be unique token
        @merchant = Merchant.find_by(id: request.headers[:merchant_id])
        return head 403 unless @merchant

        head 401 unless @merchant.active?
      end
    end
  end
end
