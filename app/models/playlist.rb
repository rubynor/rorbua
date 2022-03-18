class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_stories, dependent: :destroy

  validates :title, uniqueness: { scope: :user }
end
