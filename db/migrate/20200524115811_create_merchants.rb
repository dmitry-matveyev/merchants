class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :name
      t.text :description
      t.string :email
      t.integer :status, index: true
      t.decimal :total_transaction_sum

      t.timestamps
    end
  end
end
