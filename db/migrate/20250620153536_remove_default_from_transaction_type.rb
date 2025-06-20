class RemoveDefaultFromTransactionType < ActiveRecord::Migration[7.2]
  def change
    change_column_default :transactions, :transaction_type, from: 'expense', to: nil
  end
end
