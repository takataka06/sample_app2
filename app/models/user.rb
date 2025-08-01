class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  before_save { self.email = email.downcase }
  validates :name, presence: true,length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true#大文字・小文字を区別せずに、emailが重複してないかチェックする
  has_secure_password
  has_many :microposts, dependent: :destroy
  validates :password, presence: true, length: { minimum: 6 },allow_nil: true

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
    remember_digest 
  end
  # 記憶トークンと記憶ダイジェストを比較する # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end
  # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  def password_reset_expired?
    reset_sent_at < 2.hours.ago # パスワード再設定の有効期限を2時間に設定。設定時間が現在時刻より2時間以上前
  end
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
