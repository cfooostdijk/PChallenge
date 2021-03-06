# frozen_string_literal: true

module ApiExceptions
  APIExceptionError = Class.new(StandardError)
  UnauthorizedError = Class.new(APIExceptionError)
  ForbiddenError = Class.new(APIExceptionError)
  ApiRequestsQuotaReachedError = Class.new(APIExceptionError)
  NotFoundError = Class.new(APIExceptionError)
  UnprocessableEntityError = Class.new(APIExceptionError)
  ApiError = Class.new(APIExceptionError)
end
