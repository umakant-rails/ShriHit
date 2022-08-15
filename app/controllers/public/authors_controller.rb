class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.order("name ASC").page(params[:page]).page(params[:page]).per(10)
  end

  def show
    @author = Author.find(params[:id])
    @articles = @author.articles.page(params[:page]) rescue nil
  end

  def articles_by_author 
    @author = Author.where(name: params[:author_name].strip)[0]
    @articles = @author.articles.page(params[:page]) rescue nil
  end

end