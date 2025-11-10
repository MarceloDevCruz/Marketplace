class WelcomeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_complete

  def new
    user = current_user
    @user_info = user.build_user_info
  end

  def update
    # Enqueue asynchronous update job; immediate optimistic redirect
    UserInfos::UpdateWorker.perform_async(current_user.id, user_info_params.to_h)
    redirect_to root_path, notice: 'Atualização de perfil em processamento.'
  end

  private

  def user_info_params
    params.require(:user_info).permit(
      :first_name,
      :last_name,
      :phone,
      :date_of_birth,
      :cpf,
      :rg,
      :rg_uf,
      :gender,
      address_attributes: [
        :street,
        :number,
        :neighborhood,
        :city,
        :state,
        :zip_code,
        :complement
      ]
    )
  end

  def redirect_if_complete
    return unless profile_complete?(current_user)
    redirect_to root_path
  end

  def profile_complete?(user)
    info = user.user_info
    return false unless info
    required = [info.first_name, info.last_name, info.phone]
    required.all?(&:present?)
  end
end
