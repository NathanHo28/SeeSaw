class StoriesController < ApplicationController
  before_filter :require_login, except: [:show]

  def index
    @stories = Story.order('stories.created_at DESC').page(params[:page])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.owner_id = current_user.id
    if @story.save
      redirect_to stories_path, notice "story created successfully"
    else
      render :new
    end
  end

  def show
    @story = Story.find(params[:id])
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
    params.require(:story).permit(:title)
  end
end
