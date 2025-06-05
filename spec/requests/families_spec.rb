require 'rails_helper'

RSpec.describe 'Families', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /family/new' do
    context 'when user does not have a family' do
      it 'returns success' do
        get new_family_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the new template' do
        get new_family_path
        expect(response.body).to include('Criar Nova Família')
      end
    end

    context 'when user already has a family' do
      let!(:family) { create(:family, user: user) }

      it 'redirects to family show' do
        get new_family_path
        expect(response).to redirect_to(family_path)
      end
    end
  end

  describe 'GET /family' do
    context 'when user has a family' do
      let!(:family) { create(:family, user: user, name: 'Família Silva') }

      it 'returns success' do
        get family_path
        expect(response).to have_http_status(:success)
      end

      it 'displays family information' do
        get family_path
        expect(response.body).to include('Família Silva')
      end
    end

    context 'when user does not have a family' do
      it 'redirects to new family' do
        get family_path
        expect(response).to redirect_to(new_family_path)
      end
    end
  end

  describe 'POST /family' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          family: {
            name: 'Família Silva',
            description: 'Uma família unida'
          }
        }
      end

      it 'creates a new family' do
        expect do
          post family_path, params: valid_params
        end.to change(Family, :count).by(1)
      end

      it 'associates family with current user' do
        post family_path, params: valid_params
        expect(user.reload.family).to be_present
        expect(user.family.name).to eq('Família Silva')
      end

      it 'redirects to family show' do
        post family_path, params: valid_params
        expect(response).to redirect_to(family_path)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          family: {
            name: '',
            description: 'Sem nome'
          }
        }
      end

      it 'does not create a family' do
        expect do
          post family_path, params: invalid_params
        end.not_to change(Family, :count)
      end

      it 'renders new template with errors' do
        post family_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /family' do
    let!(:family) { create(:family, user: user, name: 'Nome Original') }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          family: {
            name: 'Nome Atualizado',
            description: 'Descrição atualizada'
          }
        }
      end

      it 'updates the family' do
        patch family_path, params: valid_params
        family.reload
        expect(family.name).to eq('Nome Atualizado')
        expect(family.description).to eq('Descrição atualizada')
      end

      it 'redirects to family show' do
        patch family_path, params: valid_params
        expect(response).to redirect_to(family_path)
      end
    end
  end

  describe 'DELETE /family' do
    let!(:family) { create(:family, user: user) }

    it 'destroys the family' do
      expect do
        delete family_path
      end.to change(Family, :count).by(-1)
    end

    it 'redirects to new family' do
      delete family_path
      expect(response).to redirect_to(new_family_path)
    end
  end
end