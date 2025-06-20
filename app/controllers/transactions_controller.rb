# Transactions controller for managing family transactions
class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_family
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = current_user.family.transactions
                                .includes(:category)

    # Apply filters based on params
    @transactions = @transactions.where(status: params[:status]) if params[:status].present?
    @transactions = @transactions.where(transaction_type: params[:transaction_type]) if params[:transaction_type].present?

    # Special filters for dashboard widgets
    if params[:overdue] == 'true'
      @transactions = @transactions.where('transaction_date < ?', Date.current)
    elsif params[:upcoming].present?
      days = params[:upcoming].to_i
      end_date = Date.current + days.days
      @transactions = @transactions.where(transaction_date: Date.current..end_date)
    end

    @transactions = @transactions.order(transaction_date: :desc)
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
      flash.now[:alert] = "Erro ao criar transação: #{@transaction.errors.full_messages.join(', ')}"
      @current_month_income = current_user.family.transactions.income.current_month.sum(:amount)
      @current_month_expenses = current_user.family.transactions.expense.current_month.sum(:amount)
      @current_month_balance = @current_month_income - @current_month_expenses

      render 'dashboard/index', status: :unprocessable_entity
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
