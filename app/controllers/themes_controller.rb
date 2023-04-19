class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_theme, only: %i[ show edit update destroy add_articles_page add_article_in_theme ]

  def index
    @themes = current_user.themes.page(params[:page])
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
          {theme_id: @theme.id, name:"#{@theme.name} अध्याय", is_default: true}
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
    @articles = Article.order("hindi_title ASC").page(params[:page])
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
    if @theme.theme_articles.where({article_id: params[:theme_article][:article_id]}).blank?
      @theme_article = current_user.theme_articles.new(theme_article_params)

      if @theme_article.save
        flash[:success] = "उत्सव में रचना सफलतापूर्वक जोड़ दी गई है."
      else
        flash[:error] = "उत्सव में रचना जोड़ने की प्रकिया असफल हो गई है."
      end
    else
      flash[:error] = "उत्सव में रचना पहले से जुडी हुई है."
    end
    get_articles_by_params

    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  def remove_article_from_theme
    @theme_chapter = ThemeChapter.find(params[:theme_chapter_id])
    @theme_article = @theme_chapter.theme_articles.find(params[:theme_article_id]) rescue nil

    if @theme_article && @theme_article.destroy
      flash[:success] = "उत्सव से रचना सफलतापूर्वक हटा दी गई है."
    else
      flash[:error] = "उत्सव में रचना हटाने की प्रकिया असफल हो गई है."
    end
    get_articles_by_params

    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  private

    def get_articles_by_params
      queryy = ''
      added_articles_tmp, articles_tmp = []
      if params[:theme_chapter_id].present?
        added_articles_tmp = ThemeChapter.find(params[:theme_chapter_id]).theme_articles.joins(:article).order("articles.hindi_title ASC")
        @added_articles = Kaminari.paginate_array(added_articles_tmp).page(params[:page])
        added_articles_tmp = added_articles_tmp.blank? ? [] : added_articles_tmp.pluck(:article_id)
      end

      if params[:search_type] == 'by_attribute'
        queryy = Article.by_attributes_query(params[:author_id], params[:context_id],
          params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
        )
       elsif params[:search_type] == 'by_id'
        queryy = "articles.id = #{params[:article_id]}"
      elsif params[:search_type] == 'by_term'
        search_term = params[:term].strip
        if params[:search_in] == "english"
          queryy = "LOWER(english_title) like '%#{search_term.downcase}%'"
        else
           queryy = "content like '%#{search_term}%'  or hindi_title like '%#{search_term}%'"
        end
      end

      articles_tmp = Article.where(queryy).where.not(id: added_articles_tmp).order("hindi_title ASC")

      @articles = Kaminari.paginate_array(articles_tmp).page(params[:page])
    end

    def set_theme
      @theme = current_user.themes.find(params[:id]) rescue nil
      if @theme.blank?
        redirect_back_or_to homes_path
      end
    end

    def theme_params
      params.fetch(:theme, {}).permit(:name)
    end

    def theme_article_params
      params.fetch(:theme_article, {}).permit(:article_id, :theme_chapter_id, :theme_id, :user_id)
    end
end
