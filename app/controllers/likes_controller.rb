class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @like = current_user.likes.new(like_params)
    respond_to do |format|
      if @like.save
        format.js
        format.html { redirect_to @like.story }
      else
        flash[:notice] = @like.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    story = @like.story
    @like.destroy
    redirect_to story
  end

  private

    def like_params
      params.require(:like).permit(:story_id)
    end

end
