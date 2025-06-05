class AddFamilyToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :transactions, :family, null: false, foreign_key: true
  end
end
