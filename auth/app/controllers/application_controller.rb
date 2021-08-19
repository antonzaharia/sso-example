class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    if session[:user_id].present?
      @current_user = User.find(session[:user_id])
    else
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
