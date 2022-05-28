class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles_by_count = Article.group_by_day(:created_at).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @artcles_by_context = Context.joins(:articles).group(:name).count
    @contexts_pending = Context.pending_for_approval
    @contexts_approved = Context.approved
    @contexts_by_approval = {pending: @contexts_pending.length, approved: @contexts_approved.length}
    @authors_pending = Author.pending_for_approval
    @authors_approved = Author.approved
  end

  def new_context_author
    
  end

end
