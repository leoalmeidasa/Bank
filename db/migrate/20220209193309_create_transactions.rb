class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :transaction_type
      t.string :account_number
      t.datetime :date_transaction
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
