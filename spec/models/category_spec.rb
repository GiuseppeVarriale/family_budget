require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:category_type) }
    it { is_expected.to validate_length_of(:description).is_at_least(2).is_at_most(100) }
  end

  describe 'enumerize' do
    it { is_expected.to enumerize(:category_type).in(:income, :expense).with_default(:expense) }
  end

  describe 'scopes' do
    let!(:income_category) { create(:category, category_type: :income) }
    let!(:expense_category) { create(:category, category_type: :expense) }

    describe '.incomes' do
      it 'returns only income categories' do
        expect(described_class.incomes).to include(income_category)
        expect(described_class.incomes).not_to include(expense_category)
      end
    end

    describe '.expenses' do
      it 'returns only expense categories' do
        expect(described_class.expenses).to include(expense_category)
        expect(described_class.expenses).not_to include(income_category)
      end
    end

    describe '.by_type' do
      it 'filters by specific type' do
        expect(described_class.by_type(:income)).to include(income_category)
        expect(described_class.by_type(:expense)).to include(expense_category)
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
      it 'returns the description of the category' do
        category.description = 'Rent'
        expect(category.to_s).to eq('Rent')
      end
    end
  end
end
