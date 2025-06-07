class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    if current_user.family.blank?
      flash[:info] = "Seja bem-vindo! O primeiro passo da sua jornada é criar sua família, assim poderemos ajuda-lo com seu orçamento."
      redirect_to new_family_path
    else
      redirect_to dashboard_path
    end
  end
end
