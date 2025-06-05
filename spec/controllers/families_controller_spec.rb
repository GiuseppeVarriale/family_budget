require 'rails_helper'

RSpec.describe FamiliesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #show' do
    context 'when user has a family' do
      let!(:family) { create(:family, user: user) }

      it 'returns a success response' do
        get :show
        expect(response).to be_successful
      end

      it 'assigns the current user family' do
        get :show
        expect(assigns(:family)).to eq(family)
      end
    end

    context "when user doesn't have a family" do
      it 'redirects to new family path' do
        get :show
        expect(response).to redirect_to(new_family_path)
      end
    end
  end

  describe 'GET #new' do
    context "when user doesn't have a family" do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
        expect(assigns(:family)).to be_a_new(Family)
      end
    end

    context 'when user already has a family' do
      let!(:family) { create(:family, user: user) }

      it 'redirects to family path' do
        get :new
        expect(response).to redirect_to(family_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { { name: 'Nova Família', description: 'Descrição da família' } }

      it 'creates a new Family' do
        expect do
          post :create, params: { family: valid_attributes }
        end.to change(Family, :count).by(1)
      end

      it 'redirects to the created family' do
        post :create, params: { family: valid_attributes }
        expect(response).to redirect_to(family_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { name: '', description: 'Descrição' } }

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { family: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let!(:family) { create(:family, user: user) }

    context 'with valid params' do
      let(:new_attributes) { { name: 'Família Atualizada' } }

      it 'updates the requested family' do
        put :update, params: { family: new_attributes }
        family.reload
        expect(family.name).to eq('Família Atualizada')
      end

      it 'redirects to the family' do
        put :update, params: { family: new_attributes }
        expect(response).to redirect_to(family_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { name: '' } }

      it 'returns unprocessable_entity status' do
        put :update, params: { family: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the family' do
        original_name = family.name
        put :update, params: { family: invalid_attributes }
        family.reload
        expect(family.name).to eq(original_name)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:family) { create(:family, user: user) }

    it 'destroys the requested family' do
      expect do
        delete :destroy
      end.to change(Family, :count).by(-1)
    end

    it 'redirects to the new family path' do
      delete :destroy
      expect(response).to redirect_to(new_family_path)
    end
  end

  describe 'GET #edit' do
    context 'when user has a family' do
      let!(:family) { create(:family, user: user) }

      it 'returns a success response' do
        get :edit
        expect(response).to be_successful
      end

      it 'assigns the family' do
        get :edit
        expect(assigns(:family)).to eq(family)
      end
    end

    context "when user doesn't have a family" do
      it 'redirects to new family path' do
        get :edit
        expect(response).to redirect_to(new_family_path)
      end
    end
  end

  describe 'POST #create when user already has a family' do
    let!(:existing_family) { create(:family, user: user) }
    let(:valid_attributes) { { name: 'Nova Família', description: 'Descrição' } }

    it 'redirects to family path without creating' do
      expect do
        post :create, params: { family: valid_attributes }
      end.not_to change(Family, :count)

      expect(response).to redirect_to(family_path)
    end
  end

  describe 'authentication' do
    before do
      sign_out user
    end

    it 'redirects to sign in for show' do
      get :show
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for new' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for create' do
      post :create, params: { family: { name: 'Test' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for edit' do
      get :edit
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for update' do
      put :update, params: { family: { name: 'Test' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for destroy' do
      delete :destroy
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
