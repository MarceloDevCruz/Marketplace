module UserInfos
  class UpdateService
    def self.call(user_id:, user_info_params:)
      new(user_id, user_info_params).call
    end

    def initialize(user_id, user_info_params)
      @user_id = user_id
      @user_info_params = user_info_params
    end

    def call
      # Validar dados usando Domain Object
      validated_params = UserInfos::Update
        .new(@user_info_params)
        .validate!
        .to_params!

      user = User.find(@user_id)
      
      ActiveRecord::Base.transaction do
        # Criar ou atualizar UserInfo
        user_info = user.user_info || user.build_user_info
        
        # Criar ou atualizar Address
        address_params = validated_params[:address_attributes] || validated_params['address_attributes']
        
        if address_params.present?
          address = user_info.address || Address.new
          address.assign_attributes(address_params)
          address.save!
          user_info.address = address
        end

        # Atualizar UserInfo (remover address_attributes antes)
        user_info_params = validated_params.dup
        user_info_params.delete(:address_attributes)
        user_info_params.delete('address_attributes')
        
        user_info.assign_attributes(user_info_params)
        user_info.save!
        
        user_info
      end
    end
  end
end

