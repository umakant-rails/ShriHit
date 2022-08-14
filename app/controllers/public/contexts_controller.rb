class Public::ContextsController < ApplicationController

  def index
    @contexts = Context.order("name ASC")
  end

  def show
    @context = Context.find(params[:id])
    @context_articles = @context.articles.page(params[:page])
  end

end
