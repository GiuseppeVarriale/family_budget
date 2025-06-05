class Category < ApplicationRecord
  extend Enumerize

  has_many :transactions, dependent: :destroy

  enumerize :category_type, in: %i[income expense], default: :expense, scope: :shallow, predicates: true

  validates :description, presence: true, length: { minimum: 2, maximum: 100 }
  validates :category_type, presence: true

  def to_s
    description
  end
end
