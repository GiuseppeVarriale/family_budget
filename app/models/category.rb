class Category < ApplicationRecord
  extend Enumerize

  has_many :transactions, dependent: :destroy

  enumerize :category_type, in: [:income, :expense], default: :expense

  validates :description, presence: true, length: { minimum: 2, maximum: 100 }
  validates :category_type, presence: true

  scope :incomes, -> { where(category_type: :income) }
  scope :expenses, -> { where(category_type: :expense) }
  scope :by_type, ->(type) { where(category_type: type) }

  def income?
    category_type == 'income'
  end

  def expense?
    category_type == 'expense'
  end

  def to_s
    description
  end
end
