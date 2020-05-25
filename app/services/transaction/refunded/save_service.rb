class Transaction < ApplicationRecord
  class Refunded < Transaction
    class SaveService < Transaction::SaveService
      def call
        resource = nil

        ApplicationRecord.transaction do
          resource = scope.new(
            amount: amount,
            uuid: generate_uuid,
            parent_id: parent_id
          )
          resource.save && resource.parent.update_column(:status, 'reversed')
        end
  
        return valid_result(uuid: resource.uuid) if resource.save
  
        invalid_result(resource.errors)
      end
    end
  end
end
