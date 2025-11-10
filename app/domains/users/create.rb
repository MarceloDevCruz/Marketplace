module Users
  class Create < Schema
    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    def validate!
      raise Error::InvalideParams.new(errors.messages) unless valid?
      self
    end

    def to_model!
      User.new(attributes)
    end
  end
end
