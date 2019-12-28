module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id #このコードを実行すると、ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成されます。
  end     #user.idはsession[:user_id]と記述することで元通りの値を取得することが可能です。（ユーザーがブラウザを閉じた瞬間に無効となります）
  
  # 永続的セッションを記憶します（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

 # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
   # 一時的セッションにいるユーザーを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

 # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in? #ログインしている状態とは、「一時的セッションにユーザーIDが存在する」ことであり、同時に先ほど定義したcurrent_userがnilではないことになります。
  #このログイン状態を論理値（trueかfalse）で返すヘルパーメソッド（logged_in?）を定義しましょう。trueはログイン状態、falseはログアウト状態を表すようにします。
    !current_user.nil? #そのため否定演算子!を利用します。
  end
end