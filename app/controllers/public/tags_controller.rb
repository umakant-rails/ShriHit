class Public::TagsController < ApplicationController

  def index
    @tags = Tag.approved.order("name ASC")
  end

  def show
    if(params[:id].blank? && params[:tag_name].present?)
      @tag = Tag.where(name: params[:tag_name].strip)[0]
    elsif params[:id].present?
      @tag = Tag.find(params[:id])
    end
    @tag_articles = @tag.articles.page(params[:page]) rescue []
  end

end
