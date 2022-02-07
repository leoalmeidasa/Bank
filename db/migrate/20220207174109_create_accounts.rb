class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.float :balance
      t.string :account_number
      t.boolean :enabled
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
