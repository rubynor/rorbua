class DislikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @dislike = current_user.dislikes.new(dislike_params)
    respond_to do |format|
      if @dislike.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("#{dom_id (@dislike.story)}_dislike_btn", partial: "dislikes/dislike_button", locals: {story: @dislike.story})
          ]
        end
      else
        flash[:notice] = @dislike.errors.full_messages.to_sentence
      end
    end

  end

  def destroy
    @dislike = current_user.dislikes.find(params[:id])
    @story = @dislike.story
    respond_to do |format|
      if @dislike.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("#{dom_id (@story)}_dislike_btn", partial: "dislikes/dislike_button", locals: {story: @story})
          ]
        end
      end
    end
  end

  private

  def dislike_params
    params.require(:dislike).permit(:story_id)
  end


end
