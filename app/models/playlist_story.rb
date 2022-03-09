class PlaylistStory < ApplicationRecord
  belongs_to :story
  belongs_to :playlist

  def next
    PlaylistStory.where("id > ? and playlist_id = ?", id, playlist_id).order(id: :asc).limit(1).first
  end

  def previous
    PlaylistStory.where("id < ? and playlist_id = ?", id, playlist_id).order(id: :asc).limit(1).first
  end

end
