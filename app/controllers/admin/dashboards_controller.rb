class Admin::DashboardsController < Admin::AppController
  before_action :authenticate_user!

  def index
    @articles_by_count = Article.group_by_day(:created_at).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @artcles_by_context = Context.joins(:articles).group(:name).count
    @contexts_by_approval = {pending: Context.pending.length, approved: Context.approved.length}
    @contexts_pending = Context.pending
    @authors_pending = Author.pending
    @authors_approved = Author.approved
  end
end
