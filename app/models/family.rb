class Family < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }

  def total_income
    transactions.income.sum(:amount)
  end

  def total_expenses
    transactions.expense.sum(:amount)
  end

  def balance
    total_income - total_expenses
  end

  def transactions_for_period(start_date, end_date)
    transactions.for_period(start_date, end_date)
  end

  def monthly_transactions(month = Date.current.month, year = Date.current.year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    transactions_for_period(start_date, end_date)
  end

  def pending_transactions
    transactions.pending
  end

  def paid_transactions
    transactions.paid
  end

  def current_month_expenses_by_category
    expenses_by_category(Date.current.beginning_of_month, Date.current.end_of_month)
  end

  def expenses_by_category(start_date = nil, end_date = nil)
    expense_transactions = if start_date && end_date
                             transactions.expense.for_period(start_date, end_date)
                           else
                             transactions.expense
                           end

    total_expenses_amount = expense_transactions.sum(:amount)
    return [] if total_expenses_amount.zero?

    expense_transactions
      .joins(:category)
      .group('categories.name')
      .sum(:amount)
      .map do |category_name, amount|
        percentage = (amount / total_expenses_amount * 100).round(1)
        {
          category: category_name,
          amount: amount,
          percentage: percentage,
          formatted_amount: "R$ #{amount.to_f.to_s.gsub('.', ',')}"
        }
      end
      .sort_by { |data| -data[:amount] }
  end

  # Pending transactions methods for dashboard widgets
  def overdue_expenses
    transactions.expense.pending.where('transaction_date < ?', Date.current)
  end

  def overdue_expenses_total
    overdue_expenses.sum(:amount)
  end

  def pending_income
    transactions.income.pending.where('transaction_date <= ?', Date.current)
  end

  def pending_income_total
    pending_income.sum(:amount)
  end

  def upcoming_expenses(days = 15)
    end_date = Date.current + days.days
    transactions.expense.pending.where(transaction_date: Date.current..end_date)
  end

  def upcoming_expenses_total(days = 15)
    upcoming_expenses(days).sum(:amount)
  end

  def upcoming_income(days = 15)
    end_date = Date.current + days.days
    transactions.income.pending.where(transaction_date: Date.current..end_date)
  end

  def upcoming_income_total(days = 15)
    upcoming_income(days).sum(:amount)
  end
end
