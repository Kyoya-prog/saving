class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound,with: :record_not_found
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_session
  before_action :require_login

  @current_user = {}

  def require_login
    render json: { code: Settings.error_codes.unauthorized,message: "user must sign in"}, status: :unauthorized if @current_user.empty?
  end

  def record_not_found
    render json: {code:Settings.error_codes.record_not_found,message: "record not found"},status: :unprocessable_entity
  end

  private
  def set_session
    #  リクエストヘッダに 'Authorization: Token hogehoge' がセットされていた場合に、トークン hogehoge を取り出せる
    authenticate_with_http_token do |token,options|
      @current_user = Session.get(token)
    end
  end
end
