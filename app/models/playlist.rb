class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_stories
end