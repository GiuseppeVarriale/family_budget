require 'rails_helper'

RSpec.describe ProfilesHelper, type: :helper do
  describe '#profile_avatar' do
    let(:user) { create(:user) }
    let(:profile) { user.profile }

    context 'when profile has an avatar attached' do
      before do
        profile.avatar.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.png')),
          filename: 'avatar.png',
          content_type: 'image/png'
        )
      end

      it 'returns an image tag with the avatar' do
        result = helper.profile_avatar(profile, size: 40)
        expect(result).to include('<img')
        expect(result).to include('class="rounded-circle"')
        expect(result).to include('width="40"')
        expect(result).to include('height="40"')
        expect(result).to include("Avatar de #{profile.full_name}")
      end

      it 'accepts custom size' do
        result = helper.profile_avatar(profile, size: 60)
        expect(result).to include('width="60"')
        expect(result).to include('height="60"')
      end

      it 'accepts custom CSS class' do
        result = helper.profile_avatar(profile, css_class: 'custom-class')
        expect(result).to include('class="custom-class"')
      end
    end

    context 'when profile has no avatar' do
      it 'returns a div with the first letter of the full name' do
        profile.update!(first_name: 'João', last_name: 'Silva')
        result = helper.profile_avatar(profile)

        expect(result).to include('<div')
        expect(result).to include('J')
        expect(result).to include('bg-secondary text-white')
        expect(result).to include('width: 40px; height: 40px')
      end

      it 'shows question mark when profile has no name' do
        allow(profile).to receive(:full_name).and_return(nil)
        result = helper.profile_avatar(profile)

        expect(result).to include('?')
      end

      it 'handles nil profile gracefully' do
        result = helper.profile_avatar(nil)

        expect(result).to include('?')
      end
    end
  end

  describe '#profile_display_name' do
    let(:profile) { create(:profile, first_name: 'João', last_name: 'Silva') }

    context 'when profile has both first and last name' do
      before do
        profile.update!(first_name: 'João', last_name: 'Silva')
      end

      it 'returns the full name' do
        expect(helper.profile_display_name(profile)).to eq('João Silva')
      end
    end

    context 'when profile has only first name' do
      it 'returns just the first name' do
        profile.update!(last_name: 'Silva') # Garantir que o campo obrigatório esteja preenchido
        profile.update_column(:last_name, nil) # Bypass da validação para simular o caso

        expect(helper.profile_display_name(profile)).to eq('João')
      end
    end

    context 'when profile has only last name' do
      it 'returns just the last name' do
        profile.update!(first_name: 'João') # Garantir que o campo obrigatório esteja preenchido
        profile.update_column(:first_name, nil) # Bypass da validação para simular o caso

        expect(helper.profile_display_name(profile)).to eq('Silva')
      end
    end

    context 'when profile has no names' do
      it 'returns default user text' do
        allow(profile).to receive(:first_name).and_return('')
        allow(profile).to receive(:last_name).and_return('')

        expect(helper.profile_display_name(profile)).to eq('Usuário')
      end
    end

    context 'when profile is nil' do
      it 'returns default user text' do
        expect(helper.profile_display_name(nil)).to eq('Usuário')
      end
    end

    context 'when profile has names with extra spaces' do
      before do
        profile.update!(first_name: '  João  ', last_name: '  Silva  ')
      end

      it 'strips extra spaces' do
        expect(helper.profile_display_name(profile)).to eq('João Silva')
      end
    end
  end
end
