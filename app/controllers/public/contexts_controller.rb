class Public::ContextsController < ApplicationController

  def index
    @contexts = Context.order("name ASC")
  end

  def show
    if(params[:id].blank? && params[:context_name].present?)
      @context = Context.where(name: params[:context_name].strip)[0]
    elsif params[:id].present?
      @context = Context.find(params[:id])
    end
    @context_articles = @context.articles.page(params[:page]) rescue []
  end

end
