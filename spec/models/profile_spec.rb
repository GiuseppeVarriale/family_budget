require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one_attached(:avatar) }
  end

  describe 'validations' do
    subject { build(:profile) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it 'is valid with valid attributes' do
      profile = build(:profile)
      expect(profile).to be_valid
    end

    it 'is not valid without a first_name' do
      profile = build(:profile, first_name: nil)
      expect(profile).not_to be_valid
      expect(profile.errors[:first_name]).to include("não pode ficar em branco")
    end

    it 'is not valid without a last_name' do
      profile = build(:profile, last_name: nil)
      expect(profile).not_to be_valid
      expect(profile.errors[:last_name]).to include("não pode ficar em branco")
    end

    it 'is not valid with empty first_name' do
      profile = build(:profile, first_name: '')
      expect(profile).not_to be_valid
    end

    it 'is not valid with empty last_name' do
      profile = build(:profile, last_name: '')
      expect(profile).not_to be_valid
    end
  end

  describe '#full_name' do
    it 'returns the full name concatenating first and last name' do
      profile = build(:profile, first_name: 'João', last_name: 'Silva')
      expect(profile.full_name).to eq('João Silva')
    end

    it 'handles names with extra spaces' do
      profile = build(:profile, first_name: ' João ', last_name: ' Silva ')
      expect(profile.full_name).to eq(' João   Silva ')
    end
  end

  describe 'avatar attachment' do
    let(:profile) { create(:profile) }

    it 'can have an avatar attached' do
      avatar = fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png')
      profile.avatar.attach(avatar)
      expect(profile.avatar).to be_attached
    end

    it 'can exist without an avatar' do
      expect(profile.avatar).not_to be_attached
      expect(profile).to be_valid
    end
  end
end
