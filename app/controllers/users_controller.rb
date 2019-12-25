class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    #debugger インスタンス変数を定義した直後にこのメソッドが実行される
  end

  def new
    @user = User.new # ユーザーオブジェクトを生成し、インスタンス変数に代入する
  end
  
  def create
    @user = User.new(user_params) #(params[:user])同じ
    if @user.save # 保存に成功した場合は、ここに記述した処理が実行される
    flash[:success] = "新規作成に成功しました。"
    redirect_to @user #redirect_to user_url(@user)同じ
    else
      render 'new'
    end
  end
  
private

  def user_params #Rails4.0以降では、セキュリティを高めるStrong Parametersと呼ばれるテクニックで対策することが標準化された
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end  
end
