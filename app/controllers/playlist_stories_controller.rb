class PlaylistStoriesController < ApplicationController
  before_action :set_variables, only: [:play, :destroy]

  def create
    story = Story.find(params[:story_id])
    playlist = Playlist.find(params[:playlist_id])
    @playlist_story = playlist.playlist_stories.build(story: story)
    respond_to do |format|
      if @playlist_story.save
        format.turbo_stream do
        end
      else
        flash[:notice] = @playlist_story.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    respond_to do |format|
      if @playlist_story.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@playlist_story)
          ]
        end
      else
        flash[:notice] = @playlist_story.errors.full_messages.to_sentence
      end
    end
  end

  def play
    if cookies[:volume].nil?
      cookies[:volume] = 75
    end
    @volume = cookies[:volume]

  end

  private

  def playliststory_params
    params.require(:playlist_story).permit(:story_id)
  end

  def set_variables
    @playlist_story = PlaylistStory.find_by(id: params[:id])
    @playlist = @playlist_story.playlist
    @story = @playlist_story.story
    @suggestions = Story.joins(:categories).where.not(id:@story).distinct.order("RANDOM()").limit(5)
    @next_in_playlist = @playlist.playlist_stories.where('created_at < ?', @playlist_story.created_at).order(created_at: :desc).limit(5)
    @stories_left = @playlist.playlist_stories.where('created_at < ?', @playlist_story.created_at).count
  end

end
