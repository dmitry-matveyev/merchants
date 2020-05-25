class AddParentIdToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :parent_id, :integer
  end
end
