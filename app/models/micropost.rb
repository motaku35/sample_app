class Micropost < ApplicationRecord
  belongs_to :user#belongs_toはユーザーと1対1の関係であることを示す
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true#ユーザidが存在するか
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

  #アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
