class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.new
  end

  def index
    if session[:user_id].present?
      token = JsonWebToken.encode(user_id: session[:user_id])
      redirect_to "#{params[:redirect_url]}?token=#{token}"
    else
      redirect_to "#{params[:redirect_url]}?token=no-user"
    end
  end

  def authenticate
    command = AuthenticateUser.call(user_params[:email], user_params[:password])

    if command.success?
      session[:user_id] = JsonWebToken.decode(command.result)[:user_id]
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def load_user
    user = User.find(params[:id])
    render json: { user: user }
  end

  def verify_token
    user = User.find(JsonWebToken.decode(auth_params[:token])[:user_id])
    render json: { user: user, token: auth_params[:token] }
  end

  def logout
    session[:user_id] = nil
    redirect_to "#{params[:redirect_url]}?token=no-user"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def auth_params
    params.require(:authentication).permit(:token)
  end
end