class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate_with_api_token!

  after_action :dont_send_cookies

  rescue_from ApiError, with: :render_api_errors
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def render_api_errors(exception)
    render json: {errors: exception}.as_json, status: exception.status
  end

  def authenticate_with_api_token!
    authenticate_with_token || render_unauthorized
  end

  def render_unauthorized
    raise ApiError.new("You need a valid token to access this API", reason: "access", status: :unauthorized)
  end

  def not_found
    render json: {errors: [{message: "We couldn't find what you are looking for", reason: "Resource Not Found"}]}, status: :not_found
  end

  def param_error(error)
    render json: {errors: [{message: error.message, attribute: error.param, reason: "validation"}]}, status: :bad_request
  end

  def authenticate_with_token
    authenticate_with_http_basic do |key, secret|
      @current_patient = Patient.authenticate(key, secret)
    end
  end

  def dont_send_cookies
    request.session_options[:skip] = true
  end

  def set_sentry_user
    return unless current_user

    Sentry.set_user({
      token_key: current_role.user.token.key,
      tenant: current_role.tenant&.name,
      account: current_role.account&.name
    })
  end
end
