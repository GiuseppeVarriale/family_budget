class AddTransactionTypeToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :transaction_type, :string, null: false, default: 'expense'
    add_index :transactions, :transaction_type
  end
end
