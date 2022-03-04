class Story < ApplicationRecord
  has_one_attached :story_file
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 250, too_long: "%{count} tegn er maks" }
  validate :acceptable_audio

  def acceptable_audio
    unless story_file.audio?
      errors.add(:story_file, "Ugyldig filformat. Du kan konvertere filen din om til MP3 med denne linken: https://cloudconvert.com/mp3-converter")
    end
  end

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
