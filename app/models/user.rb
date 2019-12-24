class User < ApplicationRecord
  before_save { self.email = email.downcase } #オブジェクトが保存される時点で処理を実行
  
  validates :name,  presence: true, length: { maximum: 50 } #name:存在性,最大50文字まで
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  #email:存在性,最大100文字まで,正規表現によるメールアドレスのフォーマット,一意であること
  validates :email, presence: true, length: { maximum: 100 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true  
  has_secure_password                                        
  validates :password, presence: true, length: { minimum: 6 } #password:存在性,最小6文字から
end
