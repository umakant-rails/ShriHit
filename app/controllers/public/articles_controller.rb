class Public::ArticlesController < ApplicationController
  layout :set_layout

  def index
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC").limit(10)
    @articles = Article.order("created_at DESC").page(params[:page]).per(5)
    @contributors = User.all
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.order("created_at DESC")
  end

  def article_by_title
    @article = Article.where(hindi_title: params[:hindi_title])[0]
    if @article.present?
      @comments = @article.comments.order("created_at DESC")
    else
      flash[:notice] = "आपके द्वारा जिस रचना की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाओं की सूची निम्नानुसार है"
      redirect_back_or_to public_articles_path
    end
  end
  # def articles_by_type
  #   @page_size = 10
  #   @articles = Article.joins(:article_type).where(article_types: {name: params[:article_type]})
  #     .page(params[:page]).per(10)
  # end

  # def articles_by_context
  #   @page_size = 10
  #   @articles = Article.joins(:context).where("contexts.name = ?",params[:context_name])
  #     .page(params[:page]).per(10)
  # end

  # def article_types
  #   @article_types = ArticleType.order("created_at ASC").page(params[:page]).per(10)
  # end

  # def article_contexts
  #   @article_contexts = Context.order("name ASC") #.page(params[:page]).per(10)
  # end

  def autocomplete_term
    search_term = params[:q].strip

    if params[:search_in] == "english"
      @articles = Article.by_search_english_term(search_term)
    else
      @articles = Article.by_search_hindi_term(search_term)
    end

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  def search
    # @added_articles, @articles = Article.get_articles_by_params(params)

    if params[:search_type] == 'by_attribute'
      queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
        params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      )
      @articles = Article.where(queryy).page(params[:page])
    elsif params[:search_type] == 'by_id'
      @articles = Article.where(id: params[:article_id]).page(params[:page])
    elsif params[:search_type] == 'by_term'
      search_term = params[:term]
      if params[:search_in] == "english"
        @articles = Article.by_search_english_term(search_term).page(params[:page])
      else
        @articles = Article.by_search_hindi_term(search_term).page(params[:page])
      end
    else
      @articles = Article.order("created_at desc").page(params[:page])
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def search_articles
    # @added_articles, @articles = Article.get_articles_by_params(params)

    if params[:search_type] == 'by_attribute'
      queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
        params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      )
      @articles = Article.where(queryy).page(params[:page])
    elsif params[:search_type] == 'by_id'
      @articles = Article.where(id: params[:article_id]).page(params[:page])
    elsif params[:search_type] == 'by_term'
      search_term = params[:term]
      if params[:search_in] == "english"
        @articles = Article.by_search_english_term(search_term).page(params[:page])
      else
        @articles = Article.by_search_hindi_term(search_term).page(params[:page])
      end
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
