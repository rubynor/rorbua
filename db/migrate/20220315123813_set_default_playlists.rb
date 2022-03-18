class SetDefaultPlaylists < ActiveRecord::Migration[7.0]
  def change
    users = User.all

    users.each do |user|

      puts "User: #{user.id}"

      playlist = user.playlists.new
      playlist.title = "Favoritter"
      playlist.public = true
      playlist.display = true

      playlist.save

      favoritter = Playlist.find_by(title: "Favoritter", user_id: user.id)

      puts "Playlist: #{favoritter.title}, id: #{favoritter.id}"

      user.favourites.each do |favourite|
        row = favoritter.playlist_stories.new
        row.story_id = favourite.story.id
        puts "Story id #{row.story_id}, playlist id: #{row.playlist_id}"
        puts row.save
      end

      #############

      pstory = user.playlists.new
      pstory.title = "Mine opplastninger"
      pstory.public = true
      pstory.display = false

      pstory.save

      mineStories = Playlist.find_by(title: "Mine opplastninger", user_id: user.id)

      puts "Playlist: #{mineStories.title}, id: #{mineStories.id}"

      user.stories.each do |story|
        row = mineStories.playlist_stories.new
        row.story_id = story.id
        puts "Story id #{row.story_id}, playlist id: #{row.playlist_id}"
        puts row.save
      end


    end

  end
end
