class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index    
  end

  def approved
    @articles_approved = Article.approved.page(params[:page])
  end

  def pending
    set_pending_records
  end

  def approve
    @article = Article.find(params[:id])
    if @article.update(is_approved: true)
      set_pending_records
      flash[:success] = "रचना को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "रचना को स्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def reject
    @article = Article.find(params[:id])
    if @article.update(is_approved: false)
      set_pending_records
      flash[:success] = "रचना को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "रचना को स्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  private

    def set_pending_records
      @articles_pending = Article.pending_for_approval.page(params[:page])
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end
end
