class Admin::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def articles_report
    @articles_approval_data = {स्वीकृत: Article.pending.count, अस्वीकृत: Article.approved.count}
    # @approved_articles = Author.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    # @pending_articles = Author.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @articles = Article.group_by_week(:created_at, week_start: :monday).count
    @articles_by_author = Author.joins(:articles).group(:name).count
    @articles_by_context = Context.joins(:articles).group(:name).count
  end

  def authors_report
    @articles_by_author = Author.joins(:articles).group(:name).count
    @approved_articles = Author.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    @pending_articles = Author.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
  end


  def contexts_report
    @articles_by_context = Context.joins(:articles).group(:name).count
    @approved_articles = Context.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    @pending_articles = Context.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
  end

  private

  def verify_admin
    if !current_user.is_admin && !current_user.is_super_admin
      redirect_to new_user_session_path
    end
  end
  
end
