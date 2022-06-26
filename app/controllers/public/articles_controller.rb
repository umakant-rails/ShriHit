class Public::ArticlesController < Public::AppController
  layout :set_layout

  def index
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @articles = Article.order("created_at DESC")
    @contributors = User.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def articles_by_type
    @articles = Article.joins(:article_type).where(article_types: {name: params[:article_type]})
  end

  def articles_by_context
    @articles = Article.joins(:context).where("contexts.name = ?",params[:context_name])
  end

  def article_pdf
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @article.english_title,
          save_to_file: @article.english_title,
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
      else
        return 'application'
      end
    end
end