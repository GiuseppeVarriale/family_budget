# Helper module for transaction-related view logic
module TransactionsHelper
  # Generate select options for categories filtered by transaction type
  def category_select_options(selected_type = nil, selected_category_id = nil)
    categories = if selected_type.present?
                   Category.where(category_type: selected_type)
                 else
                   Category.all
                 end

    options = categories.map do |category|
      [category.name, category.id]
    end

    options_for_select(options, selected_category_id)
  end
end
