class PlaylistStory < ApplicationRecord
  belongs_to :story
  belongs_to :playlist
end
