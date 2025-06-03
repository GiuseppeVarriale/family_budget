require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:profile).dependent(:destroy) }
    it { should accept_nested_attributes_for(:profile) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid with a short password' do
      user = build(:user, password: '123', password_confirmation: '123')
      expect(user).not_to be_valid
    end
  end

  describe 'roles' do
    it 'can be assigned as a regular user' do
      user = create(:user, role: 'user')
      expect(user.role).to eq('user')
    end

    it 'can be assigned as an admin' do
      admin = create(:user, :admin)
      expect(admin.role).to eq('admin')
    end
  end

  describe 'Devise modules' do
    it 'includes expected Devise modules' do
      expect(User.devise_modules).to include(:database_authenticatable)
      expect(User.devise_modules).to include(:registerable)
      expect(User.devise_modules).to include(:recoverable)
      expect(User.devise_modules).to include(:rememberable)
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'profile dependency' do
    it 'destroys associated profile when user is destroyed' do
      user = create(:user)
      user.profile # Garante que o perfil seja acessado
      profile = user.profile
      profile_id = profile.id

      user.destroy
      expect { Profile.find(profile_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
