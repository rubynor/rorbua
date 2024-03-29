class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :check_if_dislike, only: :create

  def create
    @like = current_user.likes.new(like_params)
    respond_to do |format|
      if @like.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("#{dom_id @like.story}_like_btn", partial: "likes/like_button", locals: {story: @like.story}),
            turbo_stream.update("#{dom_id (@like.story)}_dislike_btn", partial: "dislikes/dislike_button", locals: {story: @like.story})
          ]
        end
        format.html { redirect_to @like.story }
      else
        flash[:notice] = @like.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @story = @like.story
    respond_to do |format|
      @like.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("#{dom_id @story}_like_btn", partial: "likes/like_button", locals: {story: @story})
          ]
        end
    end
  end

  private

    def like_params
      params.require(:like).permit(:story_id)
    end

    def check_if_dislike
      dislike = current_user.dislikes.find_by(like_params)
      if dislike
        dislike.destroy
      end
    end

end
