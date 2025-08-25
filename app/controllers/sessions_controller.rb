class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    username = params.dig(:user, :username) || params[:username]
    password = params.dig(:user, :password) || params[:password]
    user = User.find_by(username: username)

    if user.nil?
      flash.now[:alert] = "查無使用者"
      render :new
      return
    end

    unless user.authenticate(password)
      flash.now[:alert] = "密碼錯誤"
      render :new
      return
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "登入成功"
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "已登出"
  end
end
