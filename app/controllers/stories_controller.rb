  class StoriesController < ApplicationController
  before_action :set_story, only: %i[ show edit update destroy play ]
  before_action :authenticate_user!, except: [:index, :show, :play]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :delete_from_aws, only: [:destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_story

  # GET /stories or /stories.json
  def index
    @stories = Story.all.order("created_at DESC")
  end

  def my_stories
    @stories = current_user.stories.order("created_at DESC")
  end

  def play
    if cookies[:volume].nil?
      cookies[:volume] = 75
    end
    @volume = cookies[:volume]
    $story = @story
    get_suggestions
  end

  # GET /stories/1 or /stories/1.json
  def show

  end

  # GET /stories/new
  def new
    @story = current_user.stories.build
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories or /stories.json
  def create
    #@story = Story.new(story_params)
    @story = current_user.stories.build(story_params)
    respond_to do |format|
      if @story.save
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

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url, notice: "Story slettet." }
      format.json { head :no_content }
    end
  end

  def delete_from_aws
    s3 = Aws::S3::Client.new(
      region: "eu-north-1",
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )
    s3.delete_object(bucket: 'rorbua', key: @story.story_file.key)
  end

  def correct_user
    @story = current_user.stories.find_by(id: params[:id])
    redirect_to stories_path, notice: "Du har ikke tilgang til å endre denne storyen" if @story.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    def get_suggestions
      @suggestions = Story.joins(:categories).where.not(id:@story).distinct.order("RANDOM()").limit(5)
    end

    def invalid_story
      logger.error "Attempt to access invalid story #{params[:id]}"
      redirect_to stories_path, notice: 'Ugyldig story'
    end

    # Only allow a list of trusted parameters through.
    def story_params
      params.require(:story).permit(:title, :description, :story_file, :user_id, {:category_ids=>[]})
    end

end
