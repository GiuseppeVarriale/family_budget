# Transactions controller for managing family transactions
class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_family
  before_action :set_transaction, only: %i[show edit update destroy complete_value mark_as_paid]

  def index
    @transactions = current_user.family.transactions.includes(:category)
    apply_filters
    calculate_filter_summary
    @transactions = @transactions.order(transaction_date: :desc).paginate(page: params[:page], per_page: 10)
    setup_filter_options
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
      handle_create_error
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

  def complete_value
    unless @transaction.is_approximate
      redirect_to transactions_path, alert: 'Esta transação já possui valor definido.'
      return
    end

    if @transaction.update(complete_value_params.merge(is_approximate: false))
      redirect_to transactions_path, notice: 'Valor da transação atualizado com sucesso!'
    else
      redirect_to transactions_path, alert: "Erro ao atualizar valor: #{@transaction.errors.full_messages.join(', ')}"
    end
  end

  def mark_as_paid
    unless @transaction.can_be_paid?
      redirect_to transactions_path, alert: 'Esta transação não pode ser marcada como paga.'
      return
    end

    if @transaction.mark_as_paid!
      redirect_to transactions_path, notice: 'Transação marcada como paga com sucesso!'
    else
      redirect_to transactions_path, alert: "Erro ao marcar como paga: #{@transaction.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_transaction
    @transaction = current_user.family.transactions.find(params[:id])
  end

  def filter_params
    params.permit(:month_year, :status, :transaction_type)
  end

  def apply_filters
    apply_date_filter

    apply_status_filter if filter_params[:status].present?
    apply_transaction_type_filter if filter_params[:transaction_type].present?
  end

  def calculate_filter_summary
    filtered_transactions = @transactions
    @summary_income = filtered_transactions.income.sum(:amount)
    @summary_expenses = filtered_transactions.expense.sum(:amount)
    @summary_balance = @summary_income - @summary_expenses
    @total_transactions = filtered_transactions.count
  end

  def apply_status_filter
    @transactions = @transactions.where(status: filter_params[:status])
  end

  def apply_transaction_type_filter
    @transactions = @transactions.where(transaction_type: filter_params[:transaction_type])
  end

  def apply_date_filter
    if filter_params[:month_year].present?
      year, month = filter_params[:month_year].split('-').map(&:to_i)
    else
      year = Date.current.year
      month = Date.current.month
    end

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    @transactions = @transactions.where(transaction_date: start_date..end_date)
  end

  def handle_create_error
    flash.now[:alert] = "Erro ao criar transação: #{@transaction.errors.full_messages.join(', ')}"
    set_dashboard_variables
    render 'dashboard/index', status: :unprocessable_entity
  end

  def set_dashboard_variables
    @current_month_income = current_user.family.transactions.income.current_month.sum(:amount)
    @current_month_expenses = current_user.family.transactions.expense.current_month.sum(:amount)
    @current_month_balance = @current_month_income - @current_month_expenses
  end

  def transaction_params
    params.require(:transaction).permit(
      :description, :amount, :transaction_date, :category_id,
      :status, :is_recurring, :recurring_frequency, :is_approximate,
      :transaction_type
    )
  end

  def complete_value_params
    params.require(:transaction).permit(:amount)
  end

  def setup_filter_options
    @selected_month_year = filter_params[:month_year] || Date.current.strftime('%Y-%m')
  end
end
