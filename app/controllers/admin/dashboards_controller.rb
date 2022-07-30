class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles_by_count = Article.group_by_day(:created_at).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @artcles_by_context = Context.joins(:articles).group(:name).count
    @contexts_by_approval = {pending: Context.pending.length, approved: Context.approved.length}
    @contexts_pending = Context.pending
    @authors_pending = Author.pending
    @authors_approved = Author.approved

    @articles_group_by_approval = Article.group(:is_approved).count
    @authors_group_by_approval = Author.group(:is_approved).count
    @contexts_group_by_approval = Context.group(:is_approved).count
    @spam_comment_reports = CommentReporting.not_read
    @registered_users = User.where("role_id > ?", 2)
  end
end
