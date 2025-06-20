require 'rails_helper'

RSpec.describe TransactionsHelper, type: :helper do
  describe 'category helper methods' do
    let!(:income_category) { create(:category, name: 'Salário', category_type: :income) }
    let!(:expense_category) { create(:category, name: 'Alimentação', category_type: :expense) }

    describe '#category_select_options' do
      context 'when no type is specified' do
        it 'returns all categories' do
          result = helper.category_select_options
          expect(result).to include('Salário')
          expect(result).to include('Alimentação')
        end
      end

      context 'when income type is specified' do
        it 'returns only income categories' do
          result = helper.category_select_options('income')
          expect(result).to include('Salário')
          expect(result).not_to include('Alimentação')
        end
      end

      context 'when expense type is specified' do
        it 'returns only expense categories' do
          result = helper.category_select_options('expense')
          expect(result).to include('Alimentação')
          expect(result).not_to include('Salário')
        end
      end

      context 'when selected category is provided' do
        it 'marks the category as selected' do
          result = helper.category_select_options('income', income_category.id)
          expect(result).to include("selected=\"selected\"")
        end
      end
    end

    describe '#all_category_options_with_data' do
      it 'returns all categories with data attributes' do
        result = helper.all_category_options_with_data

        expect(result).to be_an(Array)
        expect(result.length).to eq(2)

        # Check income category
        income_option = result.find { |option| option[0] == 'Salário' }
        expect(income_option).to be_present
        expect(income_option[1]).to eq(income_category.id)
        expect(income_option[2]['data-category-type']).to eq('income')

        # Check expense category
        expense_option = result.find { |option| option[0] == 'Alimentação' }
        expect(expense_option).to be_present
        expect(expense_option[1]).to eq(expense_category.id)
        expect(expense_option[2]['data-category-type']).to eq('expense')
      end
    end
  end
end
