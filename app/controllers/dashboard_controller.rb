# Dashboard controller for displaying family budget overview
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_family

  def index
    @current_month_income = current_user.family.transactions.income.current_month.sum(:amount)
    @current_month_expenses = current_user.family.transactions.expense.current_month.sum(:amount)
    @current_month_balance = @current_month_income - @current_month_expenses
    @expenses_by_category = current_user.family.current_month_expenses_by_category

    # Widget data for pending transactions
    @overdue_expenses_count = current_user.family.overdue_expenses.count
    @overdue_expenses_total = current_user.family.overdue_expenses_total
    @pending_income_count = current_user.family.pending_income.count
    @pending_income_total = current_user.family.pending_income_total
    @upcoming_expenses_count = current_user.family.upcoming_expenses(15).count
    @upcoming_expenses_total = current_user.family.upcoming_expenses_total(15)
    @upcoming_income_count = current_user.family.upcoming_income(15).count
    @upcoming_income_total = current_user.family.upcoming_income_total(15)

    # Data for widget lists with pagination
    @overdue_expenses = current_user.family.overdue_expenses.includes(:category)
                                   .order(:transaction_date).paginate(page: params[:overdue_page], per_page: 5)
    @overdue_expenses_total_count = current_user.family.overdue_expenses.count
    
    @pending_income = current_user.family.pending_income.includes(:category)
                                 .order(:transaction_date).paginate(page: params[:pending_page], per_page: 5)
    @pending_income_total_count = current_user.family.pending_income.count
    
    @upcoming_expenses = current_user.family.upcoming_expenses(15).includes(:category)
                                    .order(:transaction_date).paginate(page: params[:upcoming_exp_page], per_page: 5)
    @upcoming_expenses_total_count = current_user.family.upcoming_expenses(15).count
    
    @upcoming_income = current_user.family.upcoming_income(15).includes(:category)
                                  .order(:transaction_date).paginate(page: params[:upcoming_inc_page], per_page: 5)
    @upcoming_income_total_count = current_user.family.upcoming_income(15).count

    # Family reference for modals
    @family = current_user.family
  end

  def load_overdue_expenses
    @overdue_expenses = current_user.family.overdue_expenses.includes(:category)
                                   .order(:transaction_date).paginate(page: params[:page], per_page: 5)
    render partial: 'overdue_expenses_list', layout: false
  end

  def load_pending_income
    @pending_income = current_user.family.pending_income.includes(:category)
                                 .order(:transaction_date).paginate(page: params[:page], per_page: 5)
    render partial: 'pending_income_list', layout: false
  end

  def load_upcoming_expenses
    @upcoming_expenses = current_user.family.upcoming_expenses(15).includes(:category)
                                    .order(:transaction_date).paginate(page: params[:page], per_page: 5)
    render partial: 'upcoming_expenses_list', layout: false
  end

  def load_upcoming_income
    @upcoming_income = current_user.family.upcoming_income(15).includes(:category)
                                  .order(:transaction_date).paginate(page: params[:page], per_page: 5)
    render partial: 'upcoming_income_list', layout: false
  end
end
