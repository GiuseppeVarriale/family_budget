require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:profile) { user.profile }

  before do
    sign_in user
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit
      expect(response).to be_successful
    end

    it "assigns the user's profile" do
      get :edit
      expect(assigns(:profile)).to eq(profile)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          first_name: 'João',
          last_name: 'Silva'
        }
      end

      it 'updates the profile' do
        patch :update, params: { profile: valid_attributes }
        profile.reload
        expect(profile.first_name).to eq('João')
        expect(profile.last_name).to eq('Silva')
      end

      it 'redirects to the profile edit page' do
        patch :update, params: { profile: valid_attributes }
        expect(response).to redirect_to(edit_profile_path)
      end

      it 'sets a success notice' do
        patch :update, params: { profile: valid_attributes }
        expect(flash[:notice]).to eq('Perfil atualizado com sucesso.')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          first_name: '',
          last_name: ''
        }
      end

      it 'does not update the profile' do
        original_first_name = profile.first_name
        patch :update, params: { profile: invalid_attributes }
        profile.reload
        expect(profile.first_name).to eq(original_first_name)
      end

      it 'renders the edit template' do
        patch :update, params: { profile: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'returns unprocessable entity status' do
        patch :update, params: { profile: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with avatar upload' do
      let(:avatar_file) { fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png') }
      let(:attributes_with_avatar) do
        {
          first_name: 'João',
          last_name: 'Silva',
          avatar: avatar_file
        }
      end

      it 'attaches the avatar to the profile' do
        patch :update, params: { profile: attributes_with_avatar }
        profile.reload
        expect(profile.avatar).to be_attached
      end
    end
  end

  describe 'authentication required' do
    before do
      sign_out user
    end

    it 'redirects to login page when accessing edit without authentication' do
      get :edit
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page when accessing update without authentication' do
      patch :update, params: { profile: { first_name: 'Test' } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'private methods' do
    describe '#set_profile' do
      it "sets the current user's profile" do
        get :edit
        expect(assigns(:profile)).to eq(user.profile)
      end
    end

    describe '#profile_params' do
      it 'permits the correct parameters' do
        params = ActionController::Parameters.new(
          profile: {
            first_name: 'João',
            last_name: 'Silva',
            avatar: fixture_file_upload('spec/fixtures/files/avatar.png', 'image/png'),
            forbidden_param: 'should not be permitted'
          }
        )

        controller.params = params
        permitted_params = controller.send(:profile_params)

        expect(permitted_params.keys).to contain_exactly('first_name', 'last_name', 'avatar')
      end
    end
  end
end
