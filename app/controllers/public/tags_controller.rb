class Public::TagsController < ApplicationController

  def index
    @tags = Tag.approved.order("name ASC")
  end

  def show
    @tag = Tag.find(params[:id])
    @tag_articles = @tag.articles.page(params[:page])
  end

end