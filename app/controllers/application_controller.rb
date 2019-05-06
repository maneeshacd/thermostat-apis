class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_api_keys

  private

  def authenticate_api_keys
    api_key = request.headers['Api-Key']
    api_secret = request.headers['Api-Secret']
    if ENV['API_KEY'] == api_key && ENV['API_SECRET'] == api_secret
      true
    else
      raise_unauthorized
    end
  end

  def raise_unauthorized
    error = Error.new(code: 401, message: 'Unauthorized')
    render json: ErrorSerializer.new(error)
  end

  def record_not_found
    error = Error.new(code: 404, message: 'Object Not Found')
    render json: ErrorSerializer.new(error)
  end

  def raise_bad_request(obj)
    error = Error.new(code: 400, message: obj.errors.full_messages)
    render json: ErrorSerializer.new(error)
  end
end
