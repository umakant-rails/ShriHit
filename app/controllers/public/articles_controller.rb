class Public::ArticlesController < ApplicationController
  layout :set_layout

  def index
    @articles = Article.order("created_at DESC").page(params[:page]).per(10)
    @contributors = User.all
  end

  def show
    @article = Article.where(hindi_title: params[:id])[0] rescue nil
    if @article.present?
      @comments = @article.comments.order("created_at DESC")
    else
      flash[:notice] = "आपके द्वारा जिस रचना की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाओं की सूची निम्नानुसार है"
      redirect_back_or_to public_articles_path
    end
  end

  # def articles_by_type
  #   @articles = Article.joins(:article_type).where(article_types: {name: params[:article_type]})
  #     .page(params[:page]).per(10)
  # end

  # def articles_by_context
  #   @articles = Article.joins(:context).where("contexts.name = ?",params[:context_name])
  #     .page(params[:page]).per(10)
  # end

  # def article_contexts
  #   @article_contexts = Context.order("name ASC") #.page(params[:page]).per(10)
  # end

  def autocomplete_term
    search_term = params[:q].strip

    # if params[:search_in] == "english"
    #   @articles = Article.by_search_english_term(search_term)
    # else
    #   @articles = Article.by_search_hindi_term(search_term)
    # end
    @articles = Article.by_search_term(search_term).page(params[:page])

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search_page
    @articles = Article.order("created_at desc").page(params[:page])

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def search_articles
    if params[:search_type] == 'by_attribute'
      queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
        params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      )
      @articles = Article.where(queryy).page(params[:page])
    elsif params[:search_type] == 'by_id'
      @articles = Article.where(id: params[:article_id]).page(params[:page])
    elsif params[:search_type] == 'by_term'
      search_term = params[:term]
      # if params[:search_in] == "english"
      #   @articles = Article.by_search_english_term(search_term).page(params[:page])
      # else
      #   @articles = Article.by_search_hindi_term(search_term).page(params[:page])
      # end
      @articles = Article.by_search_term(search_term).page(params[:page])
    else
      @articles = Article.order("created_at desc").page(params[:page])
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

    def set_layout
      if params[:action] == "article_pdf"
        return "pdf_layout"
      # else
      #   return ;
      end
    end
end
