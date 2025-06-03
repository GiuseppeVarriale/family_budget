require 'rails_helper'

RSpec.describe 'Profile Integration', type: :request do
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

    it "assigns the current user's profile" do
      get edit_profile_path
      expect(assigns(:profile)).to eq(profile)
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

      it 'sets flash notice' do
        patch profile_path, params: valid_params
        follow_redirect!
        expect(response.body).to include('Perfil atualizado com sucesso.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the profile' do
        original_first_name = profile.first_name
        patch profile_path, params: invalid_params

        profile.reload
        expect(profile.first_name).to eq(original_first_name)
      end

      it 'renders the edit template' do
        patch profile_path, params: invalid_params
        expect(response).to render_template(:edit)
      end

      it 'returns unprocessable entity status' do
        patch profile_path, params: invalid_params
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
        expect(profile.avatar.filename.to_s).to eq('avatar.png')
      end
    end
  end

  describe 'authentication required' do
    before do
      sign_out user
    end

    it 'redirects to login for edit action' do
      get edit_profile_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login for update action' do
      patch profile_path, params: { profile: { first_name: 'Test' } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'profile association' do
    it 'maintains profile association after user updates' do
      new_user = create(:user)
      original_profile = new_user.profile
      new_user.update!(email: 'newemail@example.com')

      expect(new_user.profile).to eq(original_profile)
      expect(new_user.profile).to be_persisted
    end
  end
end
