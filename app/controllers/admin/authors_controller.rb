class Admin::AuthorsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @authors = Author.order("created_at DESC").page(params[:page])
  end

  def approved
    @authors_approved = Author.approved.order("created_at DESC").page(params[:page])
  end

  def pending
    set_pending_records
  end

  def approve
    @author = Author.find(params[:id])

    if @author.update(is_approved: true)
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "लेखक को स्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def reject
    @author = Author.find(params[:id])
    @unknown_author = Author.where(name: "अज्ञात")
    merge_failed = false

    ActiveRecord::Base.transaction do
      begin
        @author.articles.each do |article|
          article.update!(author_id: @unknown_author.id)
        end
        @author.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    if !merge_failed
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "लेखक को अस्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def merge
    @author = Author.find(params[:id])
    @author_merge_in = Author.find(params[:author_merge_in])
    merge_failed = false
    # binding.break
    ActiveRecord::Base.transaction do
      begin
        @author.articles.each do |article|
          article.update!(author_id: @author_merge_in.id)
        end
        @author.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    if !merge_failed 
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक विलय कर दिया है"
    else
      flash[:error] = "लेखक को विलय करने प्रकिया असफल हो गई है"
    end
  end

  def update
    @author = Author.find(params[:id])

    if @author.update(name: params[:updated_name], is_approved: true)
      set_pending_records
      flash[:success] = "लेखक का नाम सफलतापूर्वक बदल दिया गया है"
    else
      flash[:error] = "लेखक का नाम बदलने की प्रकिया असफल हो गई है"
    end
  end

  def report
    @articles_by_author = Author.joins(:articles).group(:name).count
    @approved_articles = Author.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    @pending_articles = Author.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
  end

  private

    def set_pending_records
      @authors_pending = Author.pending.order("created_at DESC").page(params[:page])
      @authors_approved = Author.approved.order("created_at DESC")
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end
end
