class PlaylistStoriesController < ApplicationController

  def create
    @playlist_story = current_user.likes.new(like_params)
    respond_to do |format|
      if @playlist_story.save
        format.turbo_stream do
          render turbo_stream: [

          ]
        end
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
