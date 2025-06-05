require 'rails_helper'

RSpec.describe 'Profile Management', type: :system do
  let!(:user) { create(:user) }
  let(:profile) { user.profile }

  before do
    driven_by(:rack_test)
    login_as(user, scope: :user)
  end

  describe 'editing profile' do
    it 'allows user to update their profile information' do
      visit edit_profile_path

      expect(page).to have_content('Meu Perfil')

      fill_in 'Nome', with: 'João'
      fill_in 'Sobrenome', with: 'Silva'

      click_button 'Atualizar Perfil'

      expect(page).to have_content('Perfil atualizado com sucesso.')
      expect(page).to have_field('Nome', with: 'João')
      expect(page).to have_field('Sobrenome', with: 'Silva')

      profile.reload
      expect(profile.first_name).to eq('João')
      expect(profile.last_name).to eq('Silva')
    end

    it 'displays validation errors for invalid data' do
      visit edit_profile_path

      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''

      click_button 'Atualizar Perfil'

      expect(page).to have_content('não pode ficar em branco')
      expect(page).not_to have_content('Perfil atualizado com sucesso.')
    end

    it 'allows user to upload an avatar' do
      visit edit_profile_path

      attach_file 'Foto de Perfil', Rails.root.join('spec', 'fixtures', 'files', 'avatar.png')
      fill_in 'Nome', with: 'João'
      fill_in 'Sobrenome', with: 'Silva'

      click_button 'Atualizar Perfil'

      expect(page).to have_content('Perfil atualizado com sucesso.')
      profile.reload
      expect(profile.avatar).to be_attached
    end

    context 'when not logged in' do
      before do
        logout(:user)
      end

      it 'redirects to login page' do
        visit edit_profile_path

        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe 'profile creation after user registration' do
    it 'automatically creates a profile when user is created' do
      new_user = create(:user)

      expect(new_user.profile).to be_present
      expect(new_user.profile).to be_persisted
    end
  end

  describe 'navigation' do
    before do
      visit edit_profile_path
    end

    it 'displays the profile edit page' do
      expect(page).to have_content('Meu Perfil')
      expect(page).to have_field('Nome')
      expect(page).to have_field('Sobrenome')
      expect(page).to have_field('Foto de Perfil')
    end

    it 'maintains user session during profile updates' do
      fill_in 'Nome', with: 'Test User'
      click_button 'Atualizar Perfil'

      expect(page).to have_content('Perfil atualizado com sucesso.')
      expect(page).to have_current_path(edit_profile_path)
    end
  end
end
