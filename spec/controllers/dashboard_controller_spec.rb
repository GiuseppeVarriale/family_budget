require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }
  let(:family) { create(:family, user: user) }

  before do
    sign_in user
    user.update(family: family)
  end

  describe 'GET #index' do
    let!(:income_transaction) { create(:transaction, :income, family: family, amount: 5000.0, transaction_date: Date.current) }
    let!(:expense_transaction) { create(:transaction, :expense, family: family, amount: 3000.0, transaction_date: Date.current) }
    let!(:last_month_transaction) { create(:transaction, :expense, family: family, amount: 1000.0, transaction_date: 1.month.ago) }

    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'calculates current month income correctly' do
      expect(assigns(:current_month_income)).to eq(5000.0)
    end

    it 'calculates current month expenses correctly' do
      expect(assigns(:current_month_expenses)).to eq(3000.0)
    end

    it 'calculates current month balance correctly' do
      expect(assigns(:current_month_balance)).to eq(2000.0)
    end

    it 'does not include transactions from previous months' do
      # The last month transaction should not be included in current month calculations
      expect(assigns(:current_month_expenses)).to eq(3000.0)
    end
  end

  describe 'when user is not authenticated' do
    before do
      sign_out user
      get :index
    end

    it 'redirects to sign in page' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'when user does not have a family' do
    let(:user_without_family) { create(:user) }

    before do
      sign_in user_without_family
      get :index
    end

    it 'redirects to new family path' do
      expect(response).to redirect_to(new_family_path)
    end

    it 'sets info flash message' do
      expect(flash[:info]).to eq("Seja bem-vindo! O primeiro passo da sua jornada é criar sua família, assim poderemos ajuda-lo com seu orçamento.")
    end
  end
end
