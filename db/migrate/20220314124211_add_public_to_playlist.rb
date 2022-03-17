class AddPublicToPlaylist < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :public, :boolean
    add_column :playlists, :display, :boolean
  end
end
