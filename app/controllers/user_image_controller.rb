class StoriesController < ApplicationController
  before_action :set_user_image, only: %i[ edit update ]

  # GET /stories/new
  def new
    @story = current_user.user_image.build
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories or /stories.json
  def create
    @story = Story.new(story_params)
    respond_to do |format|
      if current_user.save
        my_videos = current_user.playlists.find_by("title = 'Mine opplastninger'")
        my_videos.playlist_stories.build(story: @story).save
        format.html { redirect_to play_path(@story), notice: "Story ble opprettet." }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to play_path(@story), notice: "Story er oppdatert." }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def story_params
    params.require(:story).permit(:title, :description, :story_file, :user_id, {:category_ids=>[]})
  end

end
