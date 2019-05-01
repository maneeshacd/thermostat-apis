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
    render json: { status: 'Unauthorized', code: 401, data: nil,
                   message: 'Unauthorized' }
  end

  def record_not_found
    render json: { status: 'Bad Request', code: 404, data: nil,
                   message: 'Object Not Found' }
  end

  def raise_bad_request(obj)
    render json: { status: 'Bad Request', code: 400, data: nil,
                   message: obj.errors.full_messages }
  end

  def success_response(code: 200, data: nil)
    render json: {
      status: 'success', code: code, data: data, message: 'Success'
    }
  end
end
