class ProfilesController < ApplicationController
  before_action :set_user

  # GET /profiles/1 or /profiles/1.json

  def index
    @playlist = @user.playlists.find_by("title='Mine opplastninger'")
  end

  def stories
    @playlist = @user.playlists.find_by("title='Mine opplastninger'")
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("profile-content", partial: "profiles/partials/stories"),
          turbo_stream.update("profile-nav", partial:"profiles/partials/nav_items", locals: {stories: true, playlists: false})
        ]
      end
    end
  end

  # GET /profiles/1 or /profiles/1.json
  def playlists
    @playlists = @user.playlists.order("created_at DESC")
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("profile-content", partial: "profiles/partials/playlists"),
          turbo_stream.update("profile-nav", partial:"profiles/partials/nav_items", locals: {stories: false, playlists: true})
        ]
      end
    end
  end

  private

  def set_user
    @user= User.find(params[:id])
  end

end
