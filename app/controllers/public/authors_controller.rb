class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.order("name ASC").page(params[:page])
  end

  def show
    @author = Author.find(params[:id])
    @articles = @author.articles.limit(11)
  end

end