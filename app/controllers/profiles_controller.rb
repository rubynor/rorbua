class ProfilesController < ApplicationController

  # GET /profiles/1 or /profiles/1.json
  def show
    @user= User.find(params[:id])
    @playlist = @user.playlists.find_by("title='Mine opplastninger'")
  end

end
