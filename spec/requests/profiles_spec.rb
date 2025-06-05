require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let(:user) { create(:user) }
  let(:profile) { user.profile }

  before do
    sign_in user
  end

  describe 'GET /profile/edit' do
    it 'returns http success' do
      get edit_profile_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      get edit_profile_path
      expect(response).to render_template(:edit)
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to login' do
        get edit_profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /profile' do
    let(:valid_params) do
      {
        profile: {
          first_name: 'João',
          last_name: 'Silva'
        }
      }
    end

    let(:invalid_params) do
      {
        profile: {
          first_name: '',
          last_name: ''
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the profile' do
        patch profile_path, params: valid_params
        profile.reload
        expect(profile.first_name).to eq('João')
        expect(profile.last_name).to eq('Silva')
      end

      it 'redirects to edit profile page' do
        patch profile_path, params: valid_params
        expect(response).to redirect_to(edit_profile_path)
      end

      it 'sets a flash notice' do
        patch profile_path, params: valid_params
        expect(flash[:notice]).to eq('Perfil atualizado com sucesso.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the profile' do
        original_first_name = profile.first_name
        patch profile_path, params: invalid_params
        profile.reload
        expect(profile.first_name).to eq(original_first_name)
      end

      it 'renders the edit template with errors' do
        patch profile_path, params: invalid_params
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with avatar upload' do
      let(:avatar_params) do
        {
          profile: {
            first_name: 'João',
            last_name: 'Silva',
            avatar: fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png')
          }
        }
      end

      it 'attaches the avatar' do
        patch profile_path, params: avatar_params
        profile.reload
        expect(profile.avatar).to be_attached
      end
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to login' do
        patch profile_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
