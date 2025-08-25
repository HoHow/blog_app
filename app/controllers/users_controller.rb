class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 註冊成功後自動登入
      session[:user_id] = @user.id
      redirect_to root_path, notice: "註冊成功，已自動登入"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to posts_path, alert: "無權限訪問其他用戶的資料"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

end
