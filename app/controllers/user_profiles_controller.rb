class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def new
    @user_profile = UserProfile.new
  end

  def create
  end

  def profile
  end

  def profile_update
  end

end
