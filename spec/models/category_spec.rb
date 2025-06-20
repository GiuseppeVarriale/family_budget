require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:category_type) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_least(2).is_at_most(100) }
  end

  describe 'enumerize' do
    it { is_expected.to enumerize(:category_type).in(:income, :expense).with_default(:expense) }
  end

  describe 'I18n translations' do
    around do |example|
      I18n.with_locale('pt-BR') { example.run }
    end

    describe 'category_type' do
      let(:income_category) { build(:category, category_type: :income) }
      let(:expense_category) { build(:category, category_type: :expense) }

      it 'translates income to Portuguese' do
        expect(income_category.category_type.text).to eq('Receita')
      end

      it 'translates expense to Portuguese' do
        expect(expense_category.category_type.text).to eq('Despesa')
      end

      it 'provides all translated options' do
        translated_options = Category.category_type.options
        expect(translated_options).to include(['Receita', 'income'])
        expect(translated_options).to include(['Despesa', 'expense'])
      end
    end
  end

  describe 'scopes' do
    let!(:income_category) { create(:category, category_type: :income) }
    let!(:expense_category) { create(:category, category_type: :expense) }

    describe '.income' do
      it 'returns only income categories' do
        expect(described_class.income).to include(income_category)
        expect(described_class.income).not_to include(expense_category)
      end
    end

    describe '.expense' do
      it 'returns only expense categories' do
        expect(described_class.expense).to include(expense_category)
        expect(described_class.expense).not_to include(income_category)
      end
    end
  end

  describe 'instance methods' do
    describe '#income?' do
      it 'returns true for income category' do
        category.category_type = :income
        expect(category.income?).to be true
      end

      it 'returns false for expense category' do
        category.category_type = :expense
        expect(category.income?).to be false
      end
    end

    describe '#expense?' do
      it 'returns true for expense category' do
        category.category_type = :expense
        expect(category.expense?).to be true
      end

      it 'returns false for income category' do
        category.category_type = :income
        expect(category.expense?).to be false
      end
    end

    describe '#to_s' do
      it 'returns the name of the category' do
        category.name = 'Rent'
        expect(category.to_s).to eq('Rent')
      end
    end
  end
end
