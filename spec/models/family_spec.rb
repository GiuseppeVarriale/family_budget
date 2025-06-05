require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(500) }
  end

  describe 'creation' do
    it 'creates a valid family' do
      family = Family.new(name: 'Família Silva', description: 'Uma família feliz', user: user)
      expect(family).to be_valid
    end

    it 'requires a name' do
      family = Family.new(description: 'Uma família feliz', user: user)
      expect(family).not_to be_valid
      expect(family.errors[:name]).to include('não pode ficar em branco')
    end

    it 'requires a user' do
      family = Family.new(name: 'Família Silva', description: 'Uma família feliz')
      expect(family).not_to be_valid
    end
  end

  describe 'transactions association' do
    let(:family) { create(:family, user: user) }
    let(:category) { create(:category) }

    it 'can have multiple transactions' do
      transaction1 = create(:transaction, family: family, category: category)
      transaction2 = create(:transaction, family: family, category: category)

      expect(family.transactions).to include(transaction1, transaction2)
      expect(family.transactions.count).to eq(2)
    end

    it 'destroys associated transactions when family is destroyed' do
      transaction1 = create(:transaction, family: family, category: category)
      transaction2 = create(:transaction, family: family, category: category)
      transaction_ids = [transaction1.id, transaction2.id]

      expect { family.destroy }.to change { Transaction.count }.by(-2)
      expect(Transaction.where(id: transaction_ids)).to be_empty
    end
  end

  describe 'financial calculations' do
    let(:family) { create(:family, user: user) }

    before do
      create(:transaction, :income, amount: 100.00, family: family)
      create(:transaction, :income, amount: 200.00, family: family)
      create(:transaction, :expense, amount: 50.00, family: family)
      create(:transaction, :expense, amount: 75.00, family: family)
    end

    describe '#total_income' do
      it 'calculates total income from all income transactions' do
        expect(family.total_income).to eq(300.00)
      end
    end

    describe '#total_expenses' do
      it 'calculates total expenses from all expense transactions' do
        expect(family.total_expenses).to eq(125.00)
      end
    end

    describe '#balance' do
      it 'calculates the balance (income - expenses)' do
        expect(family.balance).to eq(175.00)
      end
    end
  end

  describe 'transaction filtering methods' do
    let(:family) { create(:family, user: user) }
    let(:category) { create(:category) }

    before do
      @pending_transaction = create(:transaction, :pending, family: family, category: category)
      @paid_transaction = create(:transaction, :paid, family: family, category: category)
      @cancelled_transaction = create(:transaction, :cancelled, family: family, category: category)
    end

    describe '#pending_transactions' do
      it 'returns only pending transactions' do
        expect(family.pending_transactions).to include(@pending_transaction)
        expect(family.pending_transactions).not_to include(@paid_transaction, @cancelled_transaction)
      end
    end

    describe '#paid_transactions' do
      it 'returns only paid transactions' do
        expect(family.paid_transactions).to include(@paid_transaction)
        expect(family.paid_transactions).not_to include(@pending_transaction, @cancelled_transaction)
      end
    end
  end

  describe 'period filtering methods' do
    let(:family) { create(:family, user: user) }
    let(:category) { create(:category) }

    before do
      @current_month_transaction = create(:transaction,
                                          transaction_date: Date.current.beginning_of_month + 5.days,
                                          family: family,
                                          category: category)
      @last_month_transaction = create(:transaction,
                                       transaction_date: 1.month.ago,
                                       family: family,
                                       category: category)
    end

    describe '#transactions_for_period' do
      it 'returns transactions within the specified period' do
        start_date = Date.current.beginning_of_month
        end_date = Date.current.end_of_month

        result = family.transactions_for_period(start_date, end_date)
        expect(result).to include(@current_month_transaction)
        expect(result).not_to include(@last_month_transaction)
      end
    end

    describe '#monthly_transactions' do
      it 'returns transactions for the current month by default' do
        result = family.monthly_transactions
        expect(result).to include(@current_month_transaction)
        expect(result).not_to include(@last_month_transaction)
      end

      it 'returns transactions for a specific month and year' do
        last_month_date = 1.month.ago
        result = family.monthly_transactions(last_month_date.month, last_month_date.year)
        expect(result).to include(@last_month_transaction)
        expect(result).not_to include(@current_month_transaction)
      end
    end
  end
end
