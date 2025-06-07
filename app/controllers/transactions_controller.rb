# Transactions controller for managing family transactions
class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_family
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = current_user.family.transactions
                                .includes(:category)
                                .order(transaction_date: :desc)
                                .limit(50)
  end

  def show; end

  def new
    @transaction = current_user.family.transactions.build
  end

  def create
    @transaction = current_user.family.transactions.build(transaction_params)

    if @transaction.save
      redirect_to dashboard_path, notice: 'Transação criada com sucesso!'
    else
      redirect_to dashboard_path, alert: "Erro ao criar transação: #{@transaction.errors.full_messages.join(', ')}"
    end
  end

  def edit; end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: 'Transação atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transação excluída com sucesso!'
  end

  private

  def set_transaction
    @transaction = current_user.family.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :description, :amount, :transaction_date, :category_id,
      :status, :is_recurring, :recurring_frequency, :is_approximate,
      :transaction_type
    )
  end
end
