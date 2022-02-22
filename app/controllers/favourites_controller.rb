class FavouritesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!

  # GET /favourites or /favourites.json
  def index
    @favourites = Favourite.where(user_id: current_user)
  end

  # POST /favourites or /favourites.json
  def create
    @favourite = Favourite.new
    @favourite.story = Story.find(params[:story_id])
    @favourite.user = current_user

    respond_to do |format|
      if @favourite.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update( "#{dom_id (@favourite.story)}_favourite_btn", partial: "favourites/favourite_btn", locals: {story: @favourite.story})
          ]
        end
      else
        flash[:notice] = @favourite.errors.full_messages.to_sentence
      end
    end
  end

  # DELETE /favourites/1 or /favourites/1.json
  def destroy
    @favourite = Favourite.find(params[:id])
    story = @favourite.story
    respond_to do |format|
      if @favourite.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("#{dom_id (story)}_favourite_btn", partial: "favourites/favourite_btn", locals: {story: story})
          ]
        end
      else

      end

    end
  end

end