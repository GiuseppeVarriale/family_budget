class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  protected

  def ensure_user_has_family
    return unless user_signed_in?
    return if current_user.family.present?

    flash[:info] =
      'Seja bem-vindo! O primeiro passo da sua jornada é criar sua família, assim poderemos ajuda-lo com seu orçamento.'
    redirect_to new_family_path
  end

  def user_needs_family_setup?
    user_signed_in? && current_user.family.blank?
  end
  helper_method :user_needs_family_setup?
end
