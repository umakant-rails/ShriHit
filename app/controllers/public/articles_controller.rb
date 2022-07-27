class Public::ArticlesController < ApplicationController
  layout :set_layout

  def index
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC").limit(10)
    @articles = Article.order("created_at DESC")
    @contributors = User.all
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.order("created_at DESC")
  end

  def articles_by_type
    @page_size = 10
    @articles = Article.joins(:article_type).where(article_types: {name: params[:article_type]})
      .page(params[:page]).per(10)
  end

  def articles_by_context
    @page_size = 10
    @articles = Article.joins(:context).where("contexts.name = ?",params[:context_name])
      .page(params[:page]).per(10)
  end

  def article_types
    @article_types = ArticleType.order("created_at ASC").page(params[:page]).per(10)
  end
  
  def article_contexts
    @article_contexts = Context.order("name ASC") #.page(params[:page]).per(10)
  end

  def article_pdf
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @article.hindi_title,
          save_to_file: @article.hindi_title,
          template: "public/articles/article_pdf",
          layout: "pdf_layout",
          margin: {top: 14, bottom: 14, left: 10, right: 10},
          title:  @article.english_title,
          header: {
            html: {
              template: 'public/articles/pdf_content/header',
              layout:   'pdf_plain'
            },
            line: true,
            spacing: 4
          },
          footer: {
            html: {
              template: 'public/articles/pdf_content/footer',
              layout:   'pdf_plain'
            },
            line: true,
            spacing: 4
          },
          background: true,
          show_as_html: false,
          page_size: "A4",
          encoding:"UTF-8",
          print_media_type: true
      end
    end
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
    @added_articles, @articles = Article.get_articles_by_params(params)
    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
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