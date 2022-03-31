class ProfilesController < ApplicationController

  # GET /profiles/1 or /profiles/1.json
  def stories
    @user= User.find(params[:id])
    @playlist = @user.playlists.find_by("title='Mine opplastninger'")
  end

  # GET /profiles/1 or /profiles/1.json
  def playlists
    @user= User.find(params[:id])
    @playlists = @user.playlists.order("created_at DESC")
  end

end
