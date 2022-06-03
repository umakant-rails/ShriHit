class WelcomeController < ApplicationController

  def index
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @articles = Article.order("created_at DESC")
    @contributors = User.all
  end

  def autocomplete_term
    search_term = params[:q].strip

    if params[:search_in] == "english"
      @articles = Article.where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
        "%#{search_term.downcase}%", "%#{search_term.downcase}%")
    else
      @articles = Article.where("content like ?", "%#{search_term}%")
    end
    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search_term
    # search_term = params[:term]
    # if params[:search_type] == "by_id"
    #  @articles = Article.where(id: params[:article_id])
    # elsif params[:search_type] == "by_term" && params[:search_in] == "hindi"
    #   @articles = Article.where("content like ?", "%#{search_term}%")
    # else
    #   @articles = Article.where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
    #     "%#{search_term.downcase}%", "%#{search_term.downcase}%")
    # end

    # respond_to do |format|
    #   format.html {}
    #   format.json { head :no_content }
    # end
    # render layout: false
    @added_articles, @articles = Article.get_articles_by_params(params)
    respond_to do |format|
      format.html {}
      format.js {}
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
