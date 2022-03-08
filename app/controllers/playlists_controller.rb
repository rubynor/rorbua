class PlaylistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @playlists = current_user.playlists.order("created_at DESC")
  end

  def new
    @playlist = current_user.playlists.build
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("btn-new-playlist", partial: "playlists/form", locals: { playlist: @playlist })
        ]
      end
    end
  end

  def create
    @playlist = current_user.playlists.build(playlist_params)
    respond_to do |format|
      if @playlist.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("playlists", partial: "playlists/partials/test_playlist", locals: {playlist: @playlist}),
            turbo_stream.update("playlist-form", partial: "playlists/partials/new_playlist_btn")
          ]
        end
      end
    end
  end

  def destroy

  end

  def add

  end

  def remove

  end

  private

  def playlist_params
    params.require(:playlist).permit(:title)
  end

end
