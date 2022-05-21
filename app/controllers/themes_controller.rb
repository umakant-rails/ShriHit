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
    @added_articles, @articles = Article.get_articles_by_params(params)
    #get_articles_by_params
    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  def add_article_in_theme
    if current_user.theme_articles.where(theme_article_params).blank?
      @theme_article = current_user.theme_articles.new(theme_article_params)
      if @theme_article.save
        #get_articles_by_params
        @added_articles, @articles = Article.get_articles_by_params(params)
        flash[:success] = "उत्सव में रचना सफलतापूर्वक जोड़ दी गई है."
      else
        flash[:error] = "उत्सव में रचना जोड़ने की प्रकिया असफल हो गई है."
      end
    else
      flash[:error] = "उत्सव में रचना पहले से जुडी हुई है."
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  def remove_article_from_theme
    @theme_article = current_user.theme_articles.find(params[:theme_article_id])

    if @theme_article.destroy
      # get_articles_by_params
      @added_articles, @articles = Article.get_articles_by_params(params)
      flash[:success] = "उत्सव से रचना सफलतापूर्वक हटा दी गई है."
    else
      flash[:error] = "उत्सव में रचना हटाने की प्रकिया असफल हो गई है."
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  private
    
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
