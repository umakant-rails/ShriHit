class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[ show edit update destroy tags tags_update ]

  # GET /articles or /articles.json
  def index
    @articles = current_user.articles.order("created_at DESC").page(params[:page])
  end

  # GET /articles/1 or /articles/1.json
  def show
    @comments = @article.comments.order("created_at DESC")
  end

  # GET /articles/new
  def new
    @tags = Tag.approved.order("name ASC")
    author = Author.where("name=?", "अज्ञात").first
    context = Context.where("name=?", "अन्य").first
    @scriptures = Scripture.all
    @article = Article.new({author_id: author.id, context_id: context.id})
    #@article.build_image
  end

  # GET /articles/1/edit
  def edit
    @tags = Tag.approved.order("name ASC")
  end

  # POST /articles or /articles.json
  def create
    author = Author.where("name=?", "अज्ञात").first
    params[:article][:author_id] = params[:article][:author_id].blank? ? author.id : params[:article][:author_id]

    @article = current_user.articles.new(article_params)
    respond_to do |format|
      if @article.save
        if params[:article][:tags].present?
          create_tags_for_articles
        end
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        update_tags_for_articles
        format.html { redirect_to article_url(@article), notice: "रचना को सफलतापूर्वक अद्यतित कर दिया गया है." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया हैै" }
      format.json { head :no_content }
    end
  end

  def tags
    @tags = Tag.approved.order("name ASC")
  end

  def tags_update
    update_tags_for_articles
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Tags was successfully updated." }
    end
  end

  def article_pdf
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @article.hindi_title,
          # save_to_file: Rails.root.join('pdfs', "#{@article.hindi_title}.pdf"),
          template: "articles/article_pdf",
          layout: "pdf_layout",
          margin: {top: 14, bottom: 14, left: 8, right: 8},
          title:  @article.english_title,
          header: {
            html: {
              template: 'articles/pdf_content/header',
              layout:   'pdf_plain'
            },
            line: true,
            spacing: 4
          },
          footer: {
            html: {
              template: 'articles/pdf_content/footer',
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
      @articles = Article.where("hindi_title like ? or content like ?", "%#{search_term}%", "%#{search_term}%")
    end
    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def update_tags_for_articles
      param_tags = params[:article][:tags].split(",")
      new_tags = Tag.create_tags(current_user, param_tags)

      new_tags_id = new_tags.map(&:id)

      commen_ids = new_tags_id & @article.tags.pluck(:id)

      @article.article_tags.where.not(tag_id: commen_ids).destroy_all

      (new_tags_id-commen_ids).each do | tag_id |
        current_user.article_tags.create(article_id: @article.id, tag_id: tag_id)
      end
    end

    def create_tags_for_articles
      param_tags = params[:article][:tags]
      param_tags = param_tags.index(",").blank? ? [param_tags] : param_tags.split(",")
      tags = Tag.create_tags(current_user, param_tags)
      tags.each do | tag |
        current_user.article_tags.create(article_id: @article.id, tag_id: tag.id)
      end
    end

    def set_article
      if current_user.is_super_admin or current_user.is_admin
        @article = Article.find(params[:id]) rescue nil
      else
        @article = current_user.articles.find(params[:id]) rescue nil
      end

      if @article.blank?
        redirect_back_or_to homes_path
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.fetch(:article, {}).permit(:content, :author_id, :article_type_id,
        :theme_id, :context_id, :hindi_title, :english_title, image_attributes:[:image])
    end
end
