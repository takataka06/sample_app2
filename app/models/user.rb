class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true,length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true#大文字・小文字を区別せずに、emailが重複してないかチェックする
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
