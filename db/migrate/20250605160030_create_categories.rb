class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :category_type, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :categories, :category_type
  end
end
