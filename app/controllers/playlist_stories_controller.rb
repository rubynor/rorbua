class PlaylistStoriesController < ApplicationController

  def create
    story = Story.find(params[:story_id])
    playlist = Playlist.find(params[:playlist_id])
    @playlist_story = playlist.playlist_stories.build(story: story)
    respond_to do |format|
      if @playlist_story.save
        # TODO (Legg til notice her når story blir lagt til i playlist)
      else
        flash[:notice] = @playlist_story.errors.full_messages.to_sentence
      end
    end
  end

  def destroy

  end

  private

  def playliststory_params
    params.require(:playlist_story).permit(:story_id)
  end

end
