module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id #このコードを実行すると、ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成されます。
    end     #user.idはsession[:user_id]と記述することで元通りの値を取得することが可能です。（ユーザーがブラウザを閉じた瞬間に無効となります）
  
  # セッションと@current_userを破棄します
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

 # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  def current_user #一時的セッション内のユーザーID「現在ログインしているユーザー」の値をデータベースから取得できる
    if session[:user_id] #ifの条件式としてsession[:user_id]を判定することで、一時的セッションにユーザーIDが存在しない場合このメソッドは処理を終了しnilを返すことになります。
      @current_user ||= User.find_by(id: session[:user_id]) #find_byメソッドの検索結果をインスタンス変数に代入するメリットは、「現在のユーザーを取得するためのデータベースへの問い合わせが一回で済むこと」。
       #if @current_user.nil?
       #@current_user = User.find_by(id: session[:user_id])
       #else
       #@current_user
       #end 　と同じ意味
    end    
  end

 # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in? #ログインしている状態とは、「一時的セッションにユーザーIDが存在する」ことであり、同時に先ほど定義したcurrent_userがnilではないことになります。
  #このログイン状態を論理値（trueかfalse）で返すヘルパーメソッド（logged_in?）を定義しましょう。trueはログイン状態、falseはログアウト状態を表すようにします。
    !current_user.nil? #そのため否定演算子!を利用します。
  end
end