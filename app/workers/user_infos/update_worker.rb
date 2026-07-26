class UserInfos::UpdateWorker
  include Sidekiq::Worker

  def perform(user_id, user_info_params)
    Rails.logger.info "Iniciando processamento de atualização de UserInfo para usuário #{user_id}"
    
    begin
      result = UserInfos::UpdateService.call(
        user_id: user_id,
        user_info_params: user_info_params.is_a?(Hash) ? user_info_params.with_indifferent_access : user_info_params
      )
      
      Rails.logger.info "UserInfo atualizado com sucesso para usuário #{user_id}. UserInfo ID: #{result.id}"
      result
    rescue Error::InvalidParams => e
      Rails.logger.error "Erro de validação ao atualizar UserInfo para usuário #{user_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erro de validação do ActiveRecord para usuário #{user_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    rescue StandardError => e
      Rails.logger.error "Erro inesperado ao atualizar UserInfo para usuário #{user_id}: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end

