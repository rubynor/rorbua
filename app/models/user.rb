class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :create_playlists
  has_many :stories, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_many :playlists, dependent: :destroy

  has_one_attached :user_image

  validates :user_image, file_size: { less_than_or_equal_to: 10000.kilobytes },
            file_content_type: { allow: ['image/jpeg', 'image/png'] }

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { maximum: 50 }

  private

  def create_playlists
    playlist = playlists.new
    playlist.title = "Favoritter"
    playlist.public = true
    playlist.display = true
    playlist.save

    pstory = playlists.new
    pstory.title = "Mine opplastninger"
    pstory.public = true
    pstory.display = false
    pstory.save
  end

end
