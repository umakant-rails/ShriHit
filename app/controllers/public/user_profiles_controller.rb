class Public::UserProfilesController < ApplicationController

  def index
  end

  def show
    user = User.find(params[:id])
    @user_profile = user.user_profile
  end

end
