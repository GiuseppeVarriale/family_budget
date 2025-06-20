# Transaction model representing family financial transactions
class Transaction < ApplicationRecord
  extend Enumerize

  belongs_to :category
  belongs_to :family

  enumerize :status, in: %i[pending paid cancelled], default: :pending, scope: :shallow, predicates: true
  enumerize :recurring_frequency, in: %i[weekly monthly quarterly yearly], scope: :shallow
  enumerize :transaction_type, in: %i[income expense], scope: :shallow, predicates: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 2, maximum: 200 }
  validates :transaction_date, presence: true
  validates :status, presence: true
  validates :transaction_type, presence: true
  validates :recurring_frequency, presence: true, if: :is_recurring?

  scope :recurring, -> { where(is_recurring: true) }
  scope :approximate, -> { where(is_approximate: true) }
  scope :current_month, -> { where(transaction_date: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :for_period, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_family, ->(family) { where(family: family) }

  def to_s
    description
  end

  def formatted_amount
    "R$ #{amount}"
  end

  def next_occurrence_date
    return nil unless is_recurring?

    case recurring_frequency
    when 'weekly'
      transaction_date + 1.week
    when 'monthly'
      transaction_date + 1.month
    when 'quarterly'
      transaction_date + 3.months
    when 'yearly'
      transaction_date + 1.year
    end
  end

  def can_be_cancelled?
    pending?
  end

  def can_be_paid?
    pending?
  end

  def mark_as_paid!
    update!(status: :paid)
  end

  def cancel!
    update!(status: :cancelled)
  end
end
