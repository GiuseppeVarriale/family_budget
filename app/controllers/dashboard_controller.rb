# Dashboard controller for displaying family budget overview
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_family

  def index
    @current_month_income = current_user.family.transactions.income.current_month.sum(:amount)
    @current_month_expenses = current_user.family.transactions.expense.current_month.sum(:amount)
    @current_month_balance = @current_month_income - @current_month_expenses
  end
end
