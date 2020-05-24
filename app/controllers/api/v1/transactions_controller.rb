module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_merchant

      def create
        result = Transaction::CreateService.call(permit_params.merge(merchant: @merchant))

        render json: { uuid: result }
      end

      private

      def permit_params
        params.permit(:amount)
      end

      def set_merchant
        # TODO: must be unique token
        @merchant = Merchant.find_by!(id: request.headers[:merchant_id])
      end
    end
  end
end
