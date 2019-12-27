class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #有効なユーザーオブジェクトが取得でき、パスワードも一致した場合の判定はtrue
      log_in user #(user)でもよい
      redirect_to user #(user)でもよい
    else
      flash.now[:danger] = "認証に失敗しました。"
      render 'new'
    end  
  end
  
  def destroy
    log_out
    flash[:success] = "ログアウトしました。"
    redirect_to root_path
  end  
end