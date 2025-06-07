class AddNameToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :name, :string

    Category.reset_column_information
    Category.find_each do |category|
      category.update_column(:name, category.description)
    end

    change_column_null :categories, :name, false
    add_index :categories, :name
  end
end
