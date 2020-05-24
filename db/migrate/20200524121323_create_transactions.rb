class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :merchant

      t.uuid :uuid, index: true
      t.decimal :amount
      t.string :type, index: true
      
      # TODO: add group index (merchant_id, status)
      # if we have many searches for merchant transactions of a certain status
      t.integer :status

      t.string :customer_email
      t.string :customer_phone

      t.timestamps
    end
  end
end
