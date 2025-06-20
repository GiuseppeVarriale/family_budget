require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:family) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(2).is_at_most(200) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:transaction_type) }

    context 'when is_recurring is true' do
      let(:transaction) { build(:transaction, is_recurring: true) }

      it 'validates presence of recurring_frequency' do
        transaction.recurring_frequency = nil
        expect(transaction).to_not be_valid
        expect(transaction.errors[:recurring_frequency]).to include('não pode ficar em branco quando a transação é recorrente')
      end
    end

    context 'when is_recurring is false' do
      let(:transaction) { build(:transaction, is_recurring: false) }

      it 'does not validate presence of recurring_frequency' do
        transaction.recurring_frequency = nil
        expect(transaction).to be_valid
      end
    end
  end

  describe 'enumerize' do
    it { should enumerize(:status).in(:pending, :paid, :cancelled).with_default(:pending) }
    it { should enumerize(:recurring_frequency).in(:weekly, :monthly, :quarterly, :yearly) }
    it { should enumerize(:transaction_type).in(:income, :expense) }
  end

  describe 'scopes' do
    let!(:pending_transaction) { create(:transaction, :pending) }
    let!(:paid_transaction) { create(:transaction, :paid) }
    let!(:cancelled_transaction) { create(:transaction, :cancelled) }
    let!(:recurring_transaction) { create(:transaction, :recurring) }
    let!(:approximate_transaction) { create(:transaction, :approximate) }
    let!(:income_transaction) { create(:transaction, :income) }
    let!(:expense_transaction) { create(:transaction, :expense) }

    describe '.pending' do
      it 'returns only pending transactions' do
        expect(Transaction.pending).to include(pending_transaction)
        expect(Transaction.pending).to_not include(paid_transaction, cancelled_transaction)
      end
    end

    describe '.paid' do
      it 'returns only paid transactions' do
        expect(Transaction.paid).to include(paid_transaction)
        expect(Transaction.paid).to_not include(pending_transaction, cancelled_transaction)
      end
    end

    describe '.cancelled' do
      it 'returns only cancelled transactions' do
        expect(Transaction.cancelled).to include(cancelled_transaction)
        expect(Transaction.cancelled).to_not include(pending_transaction, paid_transaction)
      end
    end

    describe '.recurring' do
      it 'returns only recurring transactions' do
        expect(Transaction.recurring).to include(recurring_transaction)
        expect(Transaction.recurring).to_not include(pending_transaction)
      end
    end

    describe '.approximate' do
      it 'returns only approximate transactions' do
        expect(Transaction.approximate).to include(approximate_transaction)
        expect(Transaction.approximate).to_not include(pending_transaction)
      end
    end

    describe '.for_period' do
      let(:start_date) { Date.current.beginning_of_month }
      let(:end_date) { Date.current.end_of_month }
      let!(:transaction_in_period) { create(:transaction, transaction_date: Date.current) }
      let!(:transaction_outside_period) { create(:transaction, transaction_date: Date.current + 2.months) }

      it 'returns transactions within the specified period' do
        result = Transaction.for_period(start_date, end_date)
        expect(result).to include(transaction_in_period)
        expect(result).to_not include(transaction_outside_period)
      end
    end

    describe '.by_category' do
      let(:category) { create(:category) }
      let!(:transaction_with_category) { create(:transaction, category: category) }
      let!(:transaction_with_other_category) { create(:transaction) }

      it 'returns transactions for the specified category' do
        result = Transaction.by_category(category)
        expect(result).to include(transaction_with_category)
        expect(result).to_not include(transaction_with_other_category)
      end
    end

    describe '.income' do
      it 'returns only income transactions' do
        expect(Transaction.income).to include(income_transaction)
        expect(Transaction.income).to_not include(expense_transaction)
      end
    end

    describe '.expense' do
      it 'returns only expense transactions' do
        expect(Transaction.expense).to include(expense_transaction)
        expect(Transaction.expense).to_not include(income_transaction)
      end
    end

    describe '.by_family' do
      let!(:family) { create(:family) }
      let!(:other_family) { create(:family) }
      let!(:transaction_with_family) { create(:transaction, family: family) }
      let!(:transaction_with_other_family) { create(:transaction, family: other_family) }

      it 'returns transactions for the specified family' do
        result = Transaction.by_family(family)
        expect(result).to include(transaction_with_family)
        expect(result).to_not include(transaction_with_other_family)
      end
    end
  end

  describe 'instance methods' do
    let(:transaction) { create(:transaction) }

    describe '#pending?' do
      it 'returns true when status is pending' do
        transaction.status = :pending
        expect(transaction.pending?).to be true
      end

      it 'returns false when status is not pending' do
        transaction.status = :paid
        expect(transaction.pending?).to be false
      end
    end

    describe '#paid?' do
      it 'returns true when status is paid' do
        transaction.status = :paid
        expect(transaction.paid?).to be true
      end

      it 'returns false when status is not paid' do
        transaction.status = :pending
        expect(transaction.paid?).to be false
      end
    end

    describe '#cancelled?' do
      it 'returns true when status is cancelled' do
        transaction.status = :cancelled
        expect(transaction.cancelled?).to be true
      end

      it 'returns false when status is not cancelled' do
        transaction.status = :pending
        expect(transaction.cancelled?).to be false
      end
    end

    describe '#income?' do
      it 'returns true when transaction_type is income' do
        transaction.transaction_type = :income
        expect(transaction.income?).to be true
      end

      it 'returns false when transaction_type is expense' do
        transaction.transaction_type = :expense
        expect(transaction.income?).to be false
      end
    end

    describe '#expense?' do
      it 'returns true when transaction_type is expense' do
        transaction.transaction_type = :expense
        expect(transaction.expense?).to be true
      end

      it 'returns false when transaction_type is income' do
        transaction.transaction_type = :income
        expect(transaction.expense?).to be false
      end
    end

    describe '#to_s' do
      it 'returns the description' do
        expect(transaction.to_s).to eq(transaction.description)
      end
    end

    describe '#formatted_amount' do
      it 'returns formatted amount with currency' do
        transaction.amount = 100.50
        expect(transaction.formatted_amount).to eq('R$ 100.5')
      end
    end

    describe '#next_occurrence_date' do
      context 'when transaction is not recurring' do
        it 'returns nil' do
          transaction.is_recurring = false
          expect(transaction.next_occurrence_date).to be_nil
        end
      end

      context 'when transaction is recurring' do
        let(:base_date) { Date.new(2024, 1, 15) }

        it 'returns next week for weekly frequency' do
          transaction.update!(is_recurring: true, recurring_frequency: :weekly, transaction_date: base_date)
          expected_date = base_date + 1.week
          expect(transaction.next_occurrence_date).to eq(expected_date)
        end

        it 'returns next month for monthly frequency' do
          transaction.update!(is_recurring: true, recurring_frequency: :monthly, transaction_date: base_date)
          expected_date = base_date + 1.month
          expect(transaction.next_occurrence_date).to eq(expected_date)
        end

        it 'returns next quarter for quarterly frequency' do
          transaction.update!(is_recurring: true, recurring_frequency: :quarterly, transaction_date: base_date)
          expected_date = base_date + 3.months
          expect(transaction.next_occurrence_date).to eq(expected_date)
        end

        it 'returns next year for yearly frequency' do
          transaction.update!(is_recurring: true, recurring_frequency: :yearly, transaction_date: base_date)
          expected_date = base_date + 1.year
          expect(transaction.next_occurrence_date).to eq(expected_date)
        end
      end
    end

    describe '#can_be_cancelled?' do
      it 'returns true when status is pending' do
        transaction.status = :pending
        expect(transaction.can_be_cancelled?).to be true
      end

      it 'returns false when status is not pending' do
        transaction.status = :paid
        expect(transaction.can_be_cancelled?).to be false
      end
    end

    describe '#can_be_paid?' do
      it 'returns true when status is pending' do
        transaction.status = :pending
        expect(transaction.can_be_paid?).to be true
      end

      it 'returns false when status is not pending' do
        transaction.status = :cancelled
        expect(transaction.can_be_paid?).to be false
      end
    end

    describe '#mark_as_paid!' do
      it 'updates status to paid' do
        transaction.status = :pending
        transaction.mark_as_paid!
        expect(transaction.reload.status).to eq('paid')
      end
    end

    describe '#cancel!' do
      it 'updates status to cancelled' do
        transaction.status = :pending
        transaction.cancel!
        expect(transaction.reload.status).to eq('cancelled')
      end
    end
  end

  describe 'I18n translations' do
    around do |example|
      I18n.with_locale('pt-BR') { example.run }
    end

    describe 'status' do
      let(:pending_transaction) { build(:transaction, status: :pending) }
      let(:paid_transaction) { build(:transaction, status: :paid) }
      let(:cancelled_transaction) { build(:transaction, status: :cancelled) }

      it 'translates pending to Portuguese' do
        expect(pending_transaction.status.text).to eq('Pendente')
      end

      it 'translates paid to Portuguese' do
        expect(paid_transaction.status.text).to eq('Pago')
      end

      it 'translates cancelled to Portuguese' do
        expect(cancelled_transaction.status.text).to eq('Cancelado')
      end

      it 'provides all translated status options' do
        translated_options = Transaction.status.options
        expect(translated_options).to include(['Pendente', 'pending'])
        expect(translated_options).to include(['Pago', 'paid'])
        expect(translated_options).to include(['Cancelado', 'cancelled'])
      end
    end

    describe 'recurring_frequency' do
      let(:weekly_transaction) { build(:transaction, recurring_frequency: :weekly) }
      let(:monthly_transaction) { build(:transaction, recurring_frequency: :monthly) }
      let(:quarterly_transaction) { build(:transaction, recurring_frequency: :quarterly) }
      let(:yearly_transaction) { build(:transaction, recurring_frequency: :yearly) }

      it 'translates weekly to Portuguese' do
        expect(weekly_transaction.recurring_frequency.text).to eq('Semanal')
      end

      it 'translates monthly to Portuguese' do
        expect(monthly_transaction.recurring_frequency.text).to eq('Mensal')
      end

      it 'translates quarterly to Portuguese' do
        expect(quarterly_transaction.recurring_frequency.text).to eq('Trimestral')
      end

      it 'translates yearly to Portuguese' do
        expect(yearly_transaction.recurring_frequency.text).to eq('Anual')
      end

      it 'provides all translated frequency options' do
        translated_options = Transaction.recurring_frequency.options
        expect(translated_options).to include(['Semanal', 'weekly'])
        expect(translated_options).to include(['Mensal', 'monthly'])
        expect(translated_options).to include(['Trimestral', 'quarterly'])
        expect(translated_options).to include(['Anual', 'yearly'])
      end
    end

    describe 'transaction_type' do
      let(:income_transaction) { build(:transaction, transaction_type: :income) }
      let(:expense_transaction) { build(:transaction, transaction_type: :expense) }

      it 'translates income to Portuguese' do
        expect(income_transaction.transaction_type.text).to eq('Receita')
      end

      it 'translates expense to Portuguese' do
        expect(expense_transaction.transaction_type.text).to eq('Despesa')
      end

      it 'provides all translated transaction_type options' do
        translated_options = Transaction.transaction_type.options
        expect(translated_options).to include(['Receita', 'income'])
        expect(translated_options).to include(['Despesa', 'expense'])
      end
    end
  end
end
