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

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, length: { maximum: 50 }

  def self.createPrevious
    users = User.all
    users.each do |user|
      user.create_playlists
      user.playlists.add_previous(user)
    end
  end

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
