class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.order("name ASC").page(params[:page]).page(params[:page]).per(10)
  end

  def show
    @author = Author.find(params[:id]) rescue nil
    @articles = @author.articles.page(params[:page]) rescue nil
    if @author.blank?
      flash[:notice] = "आपके द्वारा जिस रचनाकार की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाकारों की सूची निम्नानुसार है"
      redirect_back_or_to public_authors_path
    end
  end

  def articles_by_author
    @author = Author.where(name: params[:author_name].strip)[0]
    @articles = @author.articles.page(params[:page]) rescue nil
  end

end
