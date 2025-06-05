require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
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
end
