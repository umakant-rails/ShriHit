class WelcomeController < ApplicationController

  def index
    @articles = Article.all.order("created_at DESC").limit(10)
    @authors = Author.all.order("created_at DESC").limit(10)  
  end

  def autocomplete_term
    search_term = params[:q]
    @articles = Article.where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
      "%#{search_term.downcase}%", "%#{search_term.downcase}%")
    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search_term
    search_term = params[:search][:term]
    indexx = search_term.index(":")
    search_term = indexx.nil? ? search_term.strip : search_term[0, indexx].strip
    
    @articles = Article.where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
      "%#{search_term.downcase}%", "%#{search_term.downcase}%")

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search_article
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

end
