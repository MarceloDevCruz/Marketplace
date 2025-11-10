class Error
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class UnprocessableEntity < StandardError; end
  class InternalServerError < StandardError; end
  class InvalidParams < StandardError; end
end
