class Story < ApplicationRecord
  has_one_attached :story_file
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 250, too_long: "%{count} characters is the maximum allowed" }
  validates :story_file, presence: true, blob:{ content_type: ['audio/mpeg', 'video/mp4', 'audio/mp4']  } #For flere validations: https://github.com/aki77/activestorage-validator
  validates :story_file, file_size: { less_than: 50.megabytes }

  def next
    Story.where("id > ?", id).order(id: :asc).limit(1).first
  end

  def previous
    Story.where("id < ?", id).order(id: :desc).limit(1).first
  end

  def next_older
    Story.where("id < ?", id).order(id: :desc).limit(1).first
  end

  def previous_newer
    Story.where("id > ?", id).order(id: :asc).limit(1).first
  end

end
