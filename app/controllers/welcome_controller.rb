class WelcomeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_complete

  def new
    user = current_user
    @user_info = user.user_info || user.build_user_info
    @user_info.build_address unless @user_info.address
  end

  def update
    # Enqueue asynchronous update job
    # Convert to native JSON types for Sidekiq
    params_hash = deep_stringify_keys(user_info_params.to_h)
    UserInfos::UpdateWorker.perform_async(current_user.id, params_hash)
    
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Atualização de perfil em processamento.' }
      format.json { render json: { status: 'success', message: 'Atualização de perfil em processamento.' } }
    end
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

  def deep_stringify_keys(hash)
    case hash
    when Hash
      hash.each_with_object({}) do |(key, value), result|
        result[key.to_s] = deep_stringify_keys(value)
      end
    when Array
      hash.map { |item| deep_stringify_keys(item) }
    else
      hash
    end
  end
end
