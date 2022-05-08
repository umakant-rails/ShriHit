class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_theme, only: %i[ show edit update destroy, add_articles_page ]

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
    @theme = Theme.new(theme_params)

    respond_to do |format|
      if @theme.save
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

  def search_article
    @article = Article.find(params[:article_id])
    respond_to do |format|
      format.html {}
      format.js {}
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

  def add_articles_in_theme
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def theme_params
      params.fetch(:theme, {}).permit(:name)
    end
end
