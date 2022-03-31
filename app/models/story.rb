class Story < ApplicationRecord
  has_one_attached :story_file
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_and_belongs_to_many :categories, dependent: :destroy
  has_many :playlist_stories, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 250, too_long: "%{count} characters is the maximum allowed" }
  validates :story_file, presence: true, blob:{ content_type: ['audio/mpeg', 'video/mp4', 'audio/mp4', 'audio/x-m4a', 'video/quicktime']  } #For flere validations: https://github.com/aki77/activestorage-validator
  validates :story_file, file_size: { less_than: 50.megabytes }
  validate :category_is_selected


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

  def duration
    total_seconds = story_file.blob.metadata.fetch(:duration, nil).to_i

    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60

    format("%02d:%02d", minutes, seconds)
  end

  private

  def category_is_selected
    if self.category_ids.blank?
      self.errors.add(:category_ids, 'En til flere kategorier må være valgt')
    end
  end

end
