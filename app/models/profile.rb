class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true

  before_save :strip_names

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def strip_names
    self.first_name = first_name.strip if first_name.present?
    self.last_name = last_name.strip if last_name.present?
  end
end
