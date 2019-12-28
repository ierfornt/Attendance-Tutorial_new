class User < ApplicationRecord
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase } #オブジェクトが保存される時点で処理を実行
  
  validates :name,  presence: true, length: { maximum: 50 } #name:存在性,最大50文字まで
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  #email:存在性,最大100文字まで,正規表現によるメールアドレスのフォーマット,一意であること
  validates :email, presence: true, length: { maximum: 100 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true  
  has_secure_password                                        
  validates :password, presence: true, length: { minimum: 6 } #password:存在性,最小6文字から
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。 「ユーザーを記憶するため」のメソッド
  def remember
    self.remember_token = User.new_token #selfを記述することで仮想のremember_token属性にUser.new_tokenで生成した「ハッシュ化されたトークン情報」を代入しています。
                                         #seifがないと、単純にremember_tokenというローカル変数が作成されてしまいます。
    update_attribute(:remember_digest, User.digest(remember_token)) #update_attributeメソッドを使ってトークンダイジェストを更新しています。
  end      #↑末尾にsがあるかないかの違いがあり、こちらはバリデーションを素通りさせます。

# トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
# ユーザーのログイン情報を破棄します。ユーザーがログアウトできる「ユーザーを忘れるため」のメソッド
  def forget
    update_attribute(:remember_digest, nil)
  end
end
