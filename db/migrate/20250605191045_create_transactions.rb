class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :description, null: false
      t.datetime :transaction_date, null: false
      t.string :status, null: false, default: 'pending'
      t.boolean :is_recurring, default: false
      t.string :recurring_frequency
      t.boolean :is_approximate, default: false
      t.text :notes
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :transactions, :status
    add_index :transactions, :transaction_date
    add_index :transactions, :is_recurring
  end
end
