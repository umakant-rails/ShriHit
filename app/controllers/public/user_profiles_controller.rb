class Public::UserProfilesController < ApplicationController

  def index
    @user_profiles = User.order("username ASC").page(params[:page]).per(5)
  end

  def show
    user = User.find(params[:id])
    @user_profile = user.user_profile
  end

end
