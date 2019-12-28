class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #有効なユーザーオブジェクトが取得でき、パスワードも一致した場合の判定はtrue
      log_in user #(user)でもよい
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) 
      #チェックボックスの値を評価し, (if)オンの時はユーザー情報を記憶します。(else)オフの場合は記憶しません。
      #[条件式] ? [真（true）の場合実行される処理] : [偽（false）の場合実行される処理]
      redirect_to user #(user)でもよい
    else
      flash.now[:danger] = "認証に失敗しました。"
      render 'new'
    end  
  end
  
  def destroy
    # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_path
  end  
end