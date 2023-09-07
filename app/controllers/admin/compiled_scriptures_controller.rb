class Admin::CompiledScripturesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_scripture, only: %i[add_articles_page add_article remove_article]

  def index
    @scripture_type = ScriptureType.where(name: "प्रचलित संकलन").first
    @scriptures = @scripture_type.scriptures
  end
  
  def show
    @scripture = Scripture.find(params[:id])
    @cs_articles = @scripture.cs_articles.joins(:article).order("index").page(params[:page])
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
    is_article_exist = nil
    #if @scripture.compiled_scriptures.where({article_id: params[:compiled_scripture][:article_id]}).blank?
    params[:cs_article][:user_id] = current_user.id
    if params[:cs_article][:chapter_id].present? 
      @chapter = Chapter.find(params[:cs_article][:chapter_id])
      is_article_exist = @chapter.cs_articles.where({article_id: params[:cs_article][:article_id]})
    else
      is_article_exist = @scripture.cs_articles.where({article_id: params[:cs_article][:article_id]})
    end

    if is_article_exist.blank?
      # @compiled_scripture = current_user.compiled_scriptures.new(compiled_scripture_params)
      @cs_article = current_user.cs_articles.new(cs_article_params)

      if @cs_article.save!
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

    if @chapter.present?
      @article = @chapter.cs_articles.find(params[:cs_article_id])
    else
      @article = @scripture.cs_articles.find(params[:cs_article_id])
    end

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


  def scriptures_for_indexing
    @scripture_type = ScriptureType.where(name: "प्रचलित संकलन").first
    @scriptures = @scripture_type.scriptures
  end

  def edit_article_index
    @scripture = Scripture.find(params[:scripture_id])
    if params[:indexed] == "true"
      @cs_articles = @scripture.cs_articles.where("index is not null").page(params[:page])
    else
      @cs_articles = @scripture.cs_articles.where("index is null").page(params[:page])
    end
  end

  def update_article_index
    @scripture = Scripture.find(params[:compiled_scripture_id])
    @cs_article = @scripture.cs_articles.find(params[:article_id]) rescue nil

    respond_to do |format|
      if @cs_article.blank? and params[:bulk_updation] == "true"
        indx = 1
        @scripture = Scripture.find(params[:compiled_scripture_id])
        chapters = @scripture.chapters.present? ? @scripture.chapters.order("index") : [@scripture]

        chapters.each do | chapter | 
          chapter.cs_articles.each do | cs_article |
            cs_article.update(index: indx)
            indx = indx + 1
          end
        end    
        format.html { redirect_to admin_compiled_scriptures_path, notice: "Scripture was successfully indexed." }
      elsif @cs_article.update({index: params[:article_index]})
        get_indexed_articles
        format.html { }
        format.js { render status: 200 }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cs_article.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_chapter_articles
    @chapter = Chapter.find(params[:chapter_id]) rescue nil
    parent = @chapter.present? ? @chapter : Scripture.find(params[:compiled_scripture_id])
    @articles = parent.cs_articles.order("index ASC").page(params[:page])
  end

  def get_indexed_articles
    @chapter = Chapter.find(params[:chapter_id]) rescue nil
    parent = @chapter.present? ? @chapter : Scripture.find(params[:compiled_scripture_id])

    if params[:action_type] == "Indexed"
      @articles = parent.cs_articles.where("index is not null").order("index ASC").page(params[:page])
    elsif params[:action_type] == "Non-Indexed"
      @articles = parent.cs_articles.where("index is null").order("index ASC").page(params[:page])
    elsif params[:requested_data_type] == "Indexed"
      @articles = parent.cs_articles.where("index is not null").order("index ASC").page(params[:page])
    else
      @articles = parent.cs_articles.where("index is null").order("index ASC").page(params[:page])
    end
  end

  private

    def get_articles_by_params
      queryy = ''
      added_articles_tmp, articles_tmp = []
      if params[:chapter_id].present?
        added_articles_tmp = Chapter.find(params[:chapter_id]).cs_articles
      else
        added_articles_tmp = @scripture.cs_articles
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
