class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family, only: %i[show edit update destroy]

  def index
    redirect_to family_path if current_user.family.present?
    redirect_to new_family_path
  end

  def show
    unless current_user.family.present?
      redirect_to new_family_path
      return
    end
    @family = current_user.family
  end

  def new
    if current_user.family.present?
      redirect_to family_path
      return
    end
    @family = Family.new
  end

  def create
    if current_user.family.present?
      redirect_to family_path
      return
    end

    @family = current_user.build_family(family_params)

    if @family.save
      redirect_to family_path, notice: 'Família criada com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless current_user.family.present?
      redirect_to new_family_path
      return
    end
  end

  def update
    if @family.update(family_params)
      redirect_to family_path, notice: 'Família atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @family.destroy
    redirect_to new_family_path, notice: 'Família removida com sucesso!'
  end

  private

  def set_family
    @family = current_user.family
  end

  def family_params
    params.require(:family).permit(:name, :description)
  end
end
