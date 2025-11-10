module Users
  class CreateService
    def self.call(user_params:)
      new(user_params).call
    end

    def initialize(user_params)
      @user_params = user_params
    end

    def call
      Users::Create
        .new(@user_params)
        .validate!
        .to_model!
        .tap(&:save!)
    end
  end
end