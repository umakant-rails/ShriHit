class Public::ArticleTypesController < ApplicationController

 def index
    @article_types = ArticleType.order("name ASC")
  end

  def show
    @article_type = ArticleType.find(params[:id])
    @articles_by_type = @article_type.articles.page(params[:page])
  end

end
