class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:show, :destroy, :play]

  def index
    @playlists = current_user.playlists.order("created_at DESC")
  end

  def new
    @playlist = current_user.playlists.build
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("new_playlist_div", partial: "playlists/form", locals: { playlist: @playlist }),
          turbo_stream.update("btn-new-playlist", partial: "playlists/partials/form_cancel_btn", locals: { playlist: @playlist })
        ]
      end
    end
  end

  def cancel
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("btn-cancel-playlist-form", partial: "playlists/partials/new_playlist_btn"),
          turbo_stream.remove("playlist-form")
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
            turbo_stream.prepend("playlists_list_group", partial: "playlists/partials/playlist_list_group", locals: {playlist: @playlist}),
            turbo_stream.update("btn-cancel-playlist-form", partial: "playlists/partials/new_playlist_btn"),
            turbo_stream.remove("playlist-form")
          ]
        end
      else
        format.html { redirect_to playlists_path, notice: "Finnes spilleliste med dette navnet" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @playlist.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@playlist)
          ]
        end
      end
    end
  end

  def show

  end

  def play
    redirect_to playlist_play_story_path id: @playlist.playlist_stories.last, playlist_id: @playlist
  end

  def my_stories
    @playlist = current_user.playlists.find_by("title='Mine opplastninger'")
    Rails.logger.debug @playlist
    redirect_to @playlist
    end

  def my_favourites
    @playlist = current_user.playlists.find_by("title='Favoritter'")
    redirect_to @playlist
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :public, :display)
  end

  def set_playlist
    @playlist = current_user.playlists.find(params[:id])
    Rails.logger.debug @playlist.title
  end

end
