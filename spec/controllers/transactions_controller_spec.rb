require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:family) { create(:family, user: user) }
  let(:category) { create(:category, :income) }
  let(:transaction) { create(:transaction, family: family, category: category) }

  before do
    sign_in user
    user.update(family: family)
  end

  describe 'GET #index' do
    let!(:transactions) { create_list(:transaction, 3, family: family, category: category) }

    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns family transactions ordered by date' do
      expect(assigns(:transactions)).to eq(family.transactions.includes(:category).order(transaction_date: :desc).limit(50))
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: transaction.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the transaction' do
      expect(assigns(:transaction)).to eq(transaction)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new transaction' do
      expect(assigns(:transaction)).to be_a_new(Transaction)
      expect(assigns(:transaction).family).to eq(family)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        description: 'Salário',
        amount: 5000.0,
        transaction_date: Date.current,
        category_id: category.id,
        transaction_type: 'income'
      }
    end

    let(:invalid_attributes) do
      {
        description: '',
        amount: -100.0,
        transaction_date: nil,
        category_id: nil
      }
    end

    context 'with valid parameters' do
      it 'creates a new transaction' do
        expect {
          post :create, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
      end

      it 'redirects to dashboard' do
        post :create, params: { transaction: valid_attributes }
        expect(response).to redirect_to(dashboard_path)
      end

      it 'sets success notice' do
        post :create, params: { transaction: valid_attributes }
        expect(flash[:notice]).to eq('Transação criada com sucesso!')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new transaction' do
        expect {
          post :create, params: { transaction: invalid_attributes }
        }.not_to change(Transaction, :count)
      end

      it 'renders dashboard with error' do
        post :create, params: { transaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('dashboard/index')
        expect(assigns(:transaction).errors).to be_present
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: transaction.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the transaction' do
      expect(assigns(:transaction)).to eq(transaction)
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        description: 'Novo salário',
        amount: 6000.0
      }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: transaction.id, transaction: new_attributes } }

      it 'updates the transaction' do
        transaction.reload
        expect(transaction.description).to eq('Novo salário')
        expect(transaction.amount).to eq(6000.0)
      end

      it 'redirects to the transaction' do
        expect(response).to redirect_to(transaction)
      end
    end

    context 'with invalid parameters' do
      before { patch :update, params: { id: transaction.id, transaction: { amount: -100 } } }

      it 'does not update the transaction' do
        original_amount = transaction.amount
        transaction.reload
        expect(transaction.amount).to eq(original_amount)
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:transaction_to_delete) { create(:transaction, family: family, category: category) }

    it 'destroys the transaction' do
      expect {
        delete :destroy, params: { id: transaction_to_delete.id }
      }.to change(Transaction, :count).by(-1)
    end

    it 'redirects to transactions index' do
      delete :destroy, params: { id: transaction_to_delete.id }
      expect(response).to redirect_to(transactions_url)
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

  describe 'when accessing other family transaction' do
    let(:other_family) { create(:family) }
    let(:other_transaction) { create(:transaction, family: other_family, category: category) }

    it 'raises record not found' do
      expect {
        get :show, params: { id: other_transaction.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
