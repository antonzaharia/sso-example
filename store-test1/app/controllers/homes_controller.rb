class HomesController < ApplicationController
  def index
    if params[:token] == 'no-user'
      session[:user_id] = nil
      @print = params[:token]
    elsif params[:token].present?
      url = "http://localhost:3000/verify-token?redirect_url=#{request.original_url}"
      payload = { token: params[:token] }.to_json
      result = RestClient.post(url, payload, { content_type: :json, accept: :json })
      @user = JSON.parse(result)['user']
      session[:user_id] = @user['id']
    else
      redirect_to "http://localhost:3000?redirect_url=#{request.original_url}"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to "http://localhost:3000/logout?redirect_url=#{request.original_url}"
  end
end
