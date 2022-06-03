class Public::ArticlesController < Public::AppController

  def show
    @article = Article.find(params[:id])
  end

  def articles_by_type
    #binding.break
    @articles = Article.joins(:article_type).where(article_types: {name: params[:article_type]})
  end

  def articles_by_context
    #binding.break
    @articles = Article.joins(:context).where("contexts.name = ?",params[:context_name])
  end

end
