class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_profile, only: %i[ show edit update comments contexts authors articles ]

  def new
    @user_profile = UserProfile.new
  end

  def create
    update_user
    @user_profile = current_user.build_user_profile(user_profile_params)

    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to user_profile_url(@user_profile), notice: "User Profile was successfully created." }
        format.json { render :show, status: :created, location: @user_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    # if (current_user.id == params[:id]) && @user_profile.blank?
    #   redirect_to new_user_profile_path
    # end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user_profile.update(user_profile_params)
        format.html { redirect_to user_profile_url(@user_profile), notice: "User Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @user_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def comments
    @comments = @_user.comments
  end

  def contexts
    @contexts = @_user.contexts
  end

  def articles
    @articles = @_user.articles
  end

  def authors    
    @authors = @_user.articles
  end

  private

    def set_user_profile
      if current_user.id == params[:id]
        @_user = @user_profile
      else 
        @_user = User.find(params[:id])   
      end
      @user_profile = @_user.user_profile
    end

    def update_user
      if params[:first_name].present? || params[:last_name].present?
        user_hash = {first_name: params[:first_name], last_name: params[:last_name]}
        current_user.update(user_hash)
      end
    end

    # Only allow a list of trusted parameters through.
    def user_profile_params
      params.fetch(:user_profile, {}).permit(:first_name, :last_name, :biography, :mobile, :address, :city, :pincode, 
        :state_id, :facebook_url, :youtube_url, :date_of_birth)
    end
end
