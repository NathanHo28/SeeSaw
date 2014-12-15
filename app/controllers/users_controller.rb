class UsersController < ApplicationController
  # validates_uniqueness_of :user_id, :scope => [:follower_id, :followed_id]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.home_town.blank?
      @user.home_town = 'Your home here!'
    end
  	if @user.save
      auto_login(@user)
  		redirect_to stories_url, notice: 'Yay!'
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def follow_user
    # binding.pry
    current_user.follow(params[:user_id])
    # validates_uniqueness_of :user_id, :scope => [:follower_id, :followed_id]
  end

  def unfollow_user
    current_user.unfollow(params[:user_id])
    # validates_uniqueness_of :user_id, :scope => [:follower_id, :followed_id]
  end

  # rails will implicitly render the template corresponding
  # to an action, but action following and followers will make
  # an EXPLICIT call to render the show_follow

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to stories_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  private
  def user_params
  	params.require(:user).permit(:first_name, :last_name, :username, :email, :photo, :about_me, :home_town, :password, :password_confirmation)
  end
end
