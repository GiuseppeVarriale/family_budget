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
end
