class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # 最新の投稿が最初に来るようにする
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
