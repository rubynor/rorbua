class PlaylistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @playlists = current_user.playlists
  end

  def new
    @playlist = current_user.playlists.build
  end

  def create
    @playlist = current_user.playlists.build(playlist_params)
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
