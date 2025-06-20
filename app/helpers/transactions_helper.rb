# Helper module for transaction-related view logic
module TransactionsHelper
  # Generate select options for categories filtered by transaction type
  # When include_data_attributes is true, adds data attributes for JavaScript filtering
  def category_select_options(selected_type = nil, selected_category_id = nil, include_data_attributes: false)
    categories = fetch_categories_by_type(selected_type)
    options = build_category_options(categories, include_data_attributes)

    options_for_select(options, selected_category_id)
  end

  private

  def fetch_categories_by_type(selected_type)
    return Category.all if selected_type.blank?

    Category.where(category_type: selected_type)
  end

  def build_category_options(categories, include_data_attributes)
    categories.map do |category|
      if include_data_attributes
        [category.name, category.id, { 'data-category-type' => category.category_type }]
      else
        [category.name, category.id]
      end
    end
  end
end
