class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.order("name ASC").page(params[:page]).page(params[:page]).per(10)
  end

  def show
    @author = Author.find(params[:id])
    @articles = @author.articles.limit(11)
  end

end