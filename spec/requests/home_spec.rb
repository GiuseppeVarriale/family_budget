require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /index' do
    context 'when user is not logged in' do
      it 'returns a successful response' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        get root_path
        expect(response).to render_template(:index)
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'redirects to dashboard' do
        get root_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
