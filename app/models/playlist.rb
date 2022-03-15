class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_stories, dependent: :destroy

  validates :title, uniqueness: { scope: :user }

  def add_previous_favorites
    favourites = @user.playlists.find_by title: "Favoritter"
    @user.favourites.each do |story|
      newrecord = favourites.playlist_stories.build(story: story)
      newrecord.save
    end
  end

  def add_previous_videos
    videos = @user.playlists.find_by title: "Mine opplastninger"
    @user.stories.each do |story|
      newrecord = videos.playlist_stories.build(story: story)
      newrecord.save
    end
  end

  def self.add_previous(user)
    @user = User.find(user)
    add_previous_favorites
    add_previous_videos
  end

end
