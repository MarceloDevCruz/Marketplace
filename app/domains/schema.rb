class Schema
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def validate!
    raise NotImplementedError "not implemented"
  end
end
