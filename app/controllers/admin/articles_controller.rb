class Admin::ArticlesController < Admin::AppController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @articles = Article.order("created_at DESC").page(params[:page])
  end

  def approved
    @articles_approved = Article.approved.order("created_at DESC").page(params[:page])
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

  def report
    @articles_approval_data = {स्वीकृत: Article.pending.count, अस्वीकृत: Article.approved.count}
    # @approved_articles = Author.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    # @pending_articles = Author.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @articles = Article.group_by_week(:created_at, week_start: :monday).count
    @articles_by_author = Author.joins(:articles).group(:name).count
    @articles_by_context = Context.joins(:articles).group(:name).count
  end

  private

    def set_pending_records
      @articles_pending = Article.pending.order("created_at DESC").page(params[:page])
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end
end
