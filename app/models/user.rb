class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true,length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true#大文字・小文字を区別せずに、emailが重複してないかチェックする
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string) 
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token #これは DBには保存しない。後で cookie に入れる用に手元（インスタンス）で保持するだけ。
    update_attribute(:remember_digest, User.digest(remember_token)) #いま作った トークンをハッシュ化（digest化） して、DBカラム remember_digest に保存する。
  end
  # 記憶トークンと記憶ダイジェストを比較する # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil? # remember_digest が nil の場合は false を返す
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
