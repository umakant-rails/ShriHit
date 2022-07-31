class Admin::UserMgmtsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ block_to_user unblock_to_user]

  def index
    @users_list = User.left_outer_joins([:articles, :authors, :contexts, :comments]).unblocked_users.page(params[:page])
  end

  def blocked_users
    @users_list = User.left_outer_joins([:articles, :authors, :contexts, :comments]).blocked_users.page(params[:page])
  end

  def block_to_user
    @user_tmp.update(is_blocked: true)

    respond_to do |format|
      format.html { redirect_to admin_user_mgmts_path, notice: "User was successfully blocked." }
      format.json { head :no_content }
    end
  end

  def unblock_to_user
    @user_tmp.update(is_blocked: false)

    respond_to do |format|
      format.html { redirect_to admin_user_mgmts_path, notice: "User was successfully unblocked." }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user_tmp = User.find(params[:id])
    end

end
