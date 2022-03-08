class CreatePlaylistStories < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_stories do |t|
      t.references :story, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
