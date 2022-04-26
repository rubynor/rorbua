  class StoriesController < ApplicationController
  before_action :set_story, only: %i[ show edit update destroy play ]
  before_action :authenticate_user!, except: [:index, :show, :play]
  before_action :correct_user, only: [:edit, :update, :destroy]
  #before_action :delete_from_aws, only: [:destroy]
  #
  # uncomment for production
  #before_action only: [:destroy] do
  #  delete_from_aws("#{@story.story_file.key}")
  #end
  #before_action only: [:destroy, :update] do
  #  if @story.thumbnail.attached?
  #    delete_from_aws("#{@story.thumbnail.key}")
  #  end
  #end
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_story

  # GET /stories or /stories.json
  def index
    index_sort(params[:search_ids])
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
    get_previous
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
      #@suggestions_many = Story.joins(:categories).where(categories: @story.categories).where.not(id:@story).distinct.order("RANDOM()").limit(50)
      #@suggestions = @suggestions_many.limit(6)
      #if @suggestions.count < 30
      #  @suggestions = Story.order("RANDOM()").limit(50)
      #end
      #@next = @suggestions.order("RANDOM()").first
      @suggestions = Story.where("created_at < ? ", @story.created_at).order("created_at DESC")
      @next = @suggestions.first
    end

    def get_previous
      #session[:previous_stories] = Array.new if session[:previous_stories].nil?
      #if params[:previous_id].nil?
      #  session[:previous_stories].pop
      #  id = session[:previous_stories].last
      #  if id.nil?
      #    @previous = nil
      #  else
      #    @previous = Story.find(id)
      #  end
      #else
      #  session[:previous_stories].push params[:previous_id]
      #  @previous = Story.find(session[:previous_stories].last)
      #end
      @previous = Story.where("created_at > ?", @story.created_at).first
    end

    def invalid_story
      logger.error "Attempt to access invalid story #{params[:id]}"
      redirect_to stories_path, notice: 'Ugyldig story'
    end

    # Only allow a list of trusted parameters through.
    def story_params
      params.require(:story).permit(:title, :description, :story_file, :thumbnail, :user_id, {:category_ids=>[]})
    end

  def index_sort(id)
    #collection_boxes sender [0] alltid som "". Dermed må man sjekke om den har lengde på større enn 1, for å filtrere
    if id.nil?
      # Når man åpner index vil arraylsiten alltid være null, fordi man sjekker bruker ikke filter metoden
        @stories = Story.all.order("created_at DESC")
    else
      if id.length == 1
        # Trykker man søk utenom å ha valgt noe i modalen, skal alle vises
        @stories = Story.all.order("created_at DESC")
      else
        # Viser valgte stories, som hører til de kategoriene som er valgt
        @stories = Story.joins(:categories).where(categories: id).distinct
      end
    end
  end

end
