class HomesController < ApplicationController
  AUTH_SERVER = 'http://localhost:3000'.freeze
  HEADERS = { content_type: :json, accept: :json }.freeze

  def index
    session[:user_id].present? ? load_user : handle_token
  end

  def logout
    session[:user_id] = nil
    redirect_to "#{AUTH_SERVER}/logout?redirect_url=#{request.base_url}"
  end

  private

  def handle_token
    if params[:token] == 'no-user'
      session[:user_id] = nil
      @print = params[:token]
    elsif params[:token].present?
      url = "#{AUTH_SERVER}/verify-token"
      payload = { token: params[:token] }.to_json
      result = RestClient.post(url, payload, HEADERS)
      @user = JSON.parse(result)['user']
      session[:user_id] = @user['id']
    else
      redirect_to "#{AUTH_SERVER}?redirect_url=#{request.original_url}"
    end
  end

  def load_user
    url = "#{AUTH_SERVER}/load-user"
    payload = { id: session[:user_id] }.to_json
    result = RestClient.post(url, payload, HEADERS)
    @user = JSON.parse(result)['user']
  end
end