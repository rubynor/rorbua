class DislikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @dislike = current_user.dislikes.new(dislike_params)
    respond_to do |format|
      if @dislike.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("button_dislike", partial: "dislikes/dislike_button", locals: {dislike: @dislike})
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
      @dislike.destroy
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("button_dislike", partial: "dislikes/dislike_button", locals: {dislike: false})
        ]
      end
    end
  end

  private

  def dislike_params
    params.require(:dislike).permit(:story_id)
  end


end
