class Admin::CompiledScripturesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_scripture, only: %i[add_articles_page add_article remove_article edit_article_index]

  def index
    @scripture_type = ScriptureType.where(name: "प्रचलित संकलन").first
    @scriptures = @scripture_type.scriptures
  end
  
  def show
    @scripture = Scripture.find(params[:id])
    @cs_articles = @scripture.cs_articles.joins(:article).order("chapter_id").page(params[:page])
  end

  def add_articles_page
    @article_types = ArticleType.all
    @contexts = Context.all
    @authors = Author.all
    # @added_articles = Kaminari.paginate_array(@scriptures.articles).page(params[:page])
    # articles_tmp = Article.where(queryy).where.not(id: added_articles_tmp).order("hindi_title ASC")
    # @articles = Kaminari.paginate_array(articles_tmp).page(params[:page])
    get_articles_by_params
  end

  def search_articles
    get_articles_by_params
    respond_to do |format|
      format.html {}
      format.js {}
    end
    render layout: false
  end

  def add_article

    #if @scripture.compiled_scriptures.where({article_id: params[:compiled_scripture][:article_id]}).blank?
    if @scripture.cs_articles.where({article_id: params[:cs_article][:article_id]}).blank?
      # @compiled_scripture = current_user.compiled_scriptures.new(compiled_scripture_params)
      @cs_article = current_user.cs_articles.new(cs_article_params)

      if @cs_article.save
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

  def remove_article
    @chapter = Chapter.find(params[:chapter_id]) rescue nil
    @article = @scripture.cs_articles.find(params[:scripture_article_id])

    if @article && @article.destroy!
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

  def edit_article_index
    if params[:indexed] == "true"
      @cs_articles = @scripture.cs_articles.where("index is not null").page(params[:page])
    else
      @cs_articles = @scripture.cs_articles.where("index is null").page(params[:page])
    end
  end

  def update_article_index
    indx = 1
    @scripture = Scripture.find(params[:compiled_scripture_id])
    chapters = @scripture.chapters
    if chapters.present?
      chapters.each do | chapter | 
        chapter.cs_articles.each do | cs_article |
          cs_article.update(index: indx)
          indx = indx + 1
        end
      end
    else
      @scripture.cs_articles.each do | cs_article |
        cs_article.update(index: indx)
        indx = indx + 1
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_compiled_scriptures_path, notice: "Scripture was successfully indexed." }
      # if @cs_article.update({index: params[:article_index]})
      #   format.html { }
      #   format.js { render status: 200 }
      # else
      #   format.html { render :edit, status: :unprocessable_entity }
      #   format.json { render json: @scripture_article.errors, status: :unprocessable_entity }
      # end
    end
  end

  def get_chapter_articles
    @chapter = Chapter.find(params[:chapter_id]) rescue nil
    if @chapter.present?
      @articles = @chapter.cs_articles.order("index ASC").page(params[:page])
    else
      @scripture = Scripture.find(params[:compiled_scripture_id])
      @articles = @scripture.cs_articles.order("index ASC").page(params[:page])
    end
  end

  private

    def get_articles_by_params
      queryy = ''
      added_articles_tmp, articles_tmp = []
      if params[:chapter_id].present?
        added_articles_tmp = Chapter.find(params[:chapter_id]).articles.order("articles.hindi_title ASC")
      else
        added_articles_tmp = @scripture.articles.order("articles.hindi_title ASC")
      end

      @added_articles = Kaminari.paginate_array(added_articles_tmp).page(params[:page])
      added_articles_tmp = added_articles_tmp.blank? ? [] : added_articles_tmp.pluck(:article_id)
      

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

    def set_scripture
      @scripture = Scripture.find(params[:compiled_scripture_id])
    end

    def cs_article_params
      params.fetch(:cs_article, {}).permit(:chapter_id, :scripture_id, :article_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
