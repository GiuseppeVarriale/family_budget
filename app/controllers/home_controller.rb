class HomeController < ApplicationController
  def index
    # Redireciona usuários logados para o dashboard
    redirect_to dashboard_path if user_signed_in?
  end
end
