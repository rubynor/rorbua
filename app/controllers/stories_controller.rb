class StoriesController < ApplicationController
  before_action :set_story, only: %i[ show edit update destroy play ]
  before_action :find_all_from_id_to_last, only: :play
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :delete_from_aws, only: [:destroy]

  # GET /stories or /stories.json
  def index
    @stories = Story.all.order("created_at DESC")
  end

  def my_stories
    @stories = current_user.stories
  end

  def play_story
    @stories = Story.all
  end

  def play

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
        format.html { redirect_to story_url(@story), notice: "Story was successfully created." }
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
        format.html { redirect_to story_url(@story), notice: "Story was successfully updated." }
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
      format.html { redirect_to stories_url, notice: "Story was successfully destroyed." }
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
    redirect_to stories_path, notice: "Not Authorized To Edit This Story" if @story.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def story_params
      params.require(:story).permit(:title, :description, :story_file, :user_id)
    end

  def find_all_from_id_to_last
    @stories = Story.where('id >= ?', @story.id).limit(20)
  end

end
