class Story < ApplicationRecord
  has_one_attached :story_file
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :likes
  has_many :dislikes

  validates :title, :description, presence: true
  validates :description, length: { maximum: 250 }
  validates :story_file, presence: true, blob:{ content_type: :audio } #For flere validations: https://github.com/aki77/activestorage-validator

  def next
    Story.where("id > ?", id).order(id: :asc).limit(1).first
  end

  def previous
    Story.where("id < ?", id).order(id: :desc).limit(1).first
  end

end
