class StoriesController < ApplicationController
  # before_filter :require_login, except: [:index, :show]

  def index
    @stories = if params[:story]
      search
    else
      Story.order('stories.created_at DESC')
    end.page(params[:page])
  end

  def feed_items
    @stories = Kaminari.paginate_array(current_user.feed)
  end

  def search
    sanity_check = story_params.delete_if {|category, value| value.blank? || value == 0}
    @stories = Story.all
    sanity_check.each do |key, column|
      case key
      when "title"
        @stories = Story.where(["#{key} iLIKE ?", "%#{column}%"])
      when "tag_list"
        @stories = @stories.tagged_with("#{column}", :any => true)
      when "created_at"
        if column == "Oldest"
          @stories = @stories.order('stories.created_at')
        else
          @stories = @stories.order('stories.created_at DESC')
        end
      when "cached_votes_score"
          @stories = @stories.order('stories.cached_votes_score DESC')
      when "city"
        @stories = @stories.where(["#{key} iLIKE ?", "%#{column}%"])
      when "state"
        @stories = @stories.where(["#{key} iLIKE ?", "%#{column}%"])
      when "country"
        @stories = @stories.where(["#{key} iLIKE ?", "%#{column}%"])
      end

    end
    @stories
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.owner = current_user
    if @story.save
      redirect_to stories_path, notice: "story created successfully"
    else
      render :new
    end
  end

  def upvote
    @story = Story.find(params[:id])
    @story.upvote_by current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def tagged
    if params[:tag].present?
      @stories = Story.tagged_with(params[:tag])
    else
      @stories = Story.all
    end
  end

  def show
    @story = Story.find(params[:id])
    if current_user
      @comment = @story.comments.build
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])
    if @story.update_attributes(story_params)
      redirect_to stories_path(@story), notice: "story has been updated"
    else
      render :edit
    end
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    redirect_to stories_path, notice: "story has been removed"
  end

  private
  def story_params
    params.require(:story).permit(:title, :cached_votes_score, :tag_list, :created_at, :latitude, :longitude, :city, :state, :country,  pages_attributes: [:id, :page_photo, :caption, :page_number, :story_id])
  end
end

