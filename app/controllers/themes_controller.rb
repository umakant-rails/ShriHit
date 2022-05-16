class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_theme, only: %i[ show edit update destroy add_articles_page add_article_in_theme ]

  def index
    @themes = Theme.all
  end

  def show
  end

  def new
    @theme = Theme.new
  end

  def edit
  end

  def create
    @theme = current_user.themes.new(theme_params)

    respond_to do |format|
      if @theme.save
        current_user.theme_chapters.create(
          {theme_id: @theme.id, name:"#{@theme.name}_विविध _प्रकरण", is_default: true}
        )
        format.html { redirect_to theme_url(@theme), notice: "Theme was successfully created." }
        format.json { render :show, status: :created, location: @theme }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @theme.update(theme_params)
        format.html { redirect_to theme_url(@theme), notice: "Theme was successfully updated." }
        format.json { render :show, status: :ok, location: @theme }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to themes_url, notice: "Theme was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_articles_page
    @article_types = ArticleType.all
    @contexts = Context.all
    @authors = Author.all
    @articles = Article.all
    @theme_chapters = @theme.theme_chapters
  end

  def search_articles
    get_articles_by_params
    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  def add_article_in_theme
    @theme_article = current_user.theme_articles.new(theme_article_params)

    if @theme_article.save
      get_articles_by_params
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  private
   
    def get_articles_by_params
      if params[:search_type] == 'by_attribute'
        @articles = Article.by_attributes(params[:author_id], params[:context_id], 
          params[:article_type_id], params[:theme_chapter_id]
        )
      elsif params[:search_type] == 'by_id'
        @articles = Article.by_id(params[:article_id])
      elsif params[:search_type] == 'by_term'
        @articles = Article.by_search_term(params[:term])
      else
        @articles = Article.order("created_at desc")
      end
      @added_articles = Article.joins(:theme_articles)._chapter_articles(params[:theme_chapter_id])
      @articles = @articles._except_chapter_articles(params[:theme_chapter_id])   
    end
    
    def set_theme
      @theme = Theme.find(params[:id])
    end

    def theme_params
      params.fetch(:theme, {}).permit(:name)
    end

    def theme_article_params
      params.fetch(:theme_article, {}).permit(:article_id, :theme_chapter_id, :theme_id, :user_id)
    end
end
