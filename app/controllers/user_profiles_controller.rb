class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_profile, only: %i[ show edit update ]

  def new
    @user_profile = UserProfile.new
  end

  def create
    update_user

    @user_profile = current_user.user_profile.new(user_profile_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to user_profile_url(@user_profile), notice: "User Profile was successfully created." }
        format.json { render :show, status: :created, location: @user_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if @user_profile.blank?
      redirect_to new_user_profile_path
    end
  end

  def edit
  end

  private

    def set_user_profile
      @user_profile = current_user.user_profile
    end

    def update_user
      if params[:first_name].present? || params[:last_name].present?
        user_hash = {first_name: params[:first_name], last_name: params[:last_name]}
        current_user.update(user_hash)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_profile_params
      params.fetch(:user_profile, {}).permit(:biography, :mobile, :address, :city, :pincode, 
        :state_id, :facebook_url, :youtube_url, :date_of_birth)
    end
end
