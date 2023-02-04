class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_article, only: %i[show edit update destroy tags tags_update ]

  def index
    @articles = Article.order("created_at DESC").page(params[:page])
  end

  def show
    @comments = @article.comments.order("created_at DESC")
  end

  def edit
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        update_tags_for_articles
        format.html { redirect_to article_url(@article), notice: "रचना को सफलतापूर्वक अद्यतित कर दिया गया है." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity,
          error: "रचना को अद्यतित करने की प्रकिया असफल हो गई हैै." }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def tags
    @tags = Tag.approved.order("name ASC")
  end

  def tags_update
    update_tags_for_articles
    respond_to do |format|
      format.html { redirect_to admin_article_url(@article), notice: "Tags was successfully updated." }
    end
  end

  def approved
    @articles_approved = Article.joins([:author, :context]).approved.order("created_at DESC").page(params[:page])
  end

  def pending
    @articles_pending = Article.joins([:author, :context]).pending.order("created_at DESC").page(params[:page])
  end

  def rejected
    @articles_rejected = Article.rejected.order("created_at DESC").page(params[:page])
  end

  def approve
    @article = Article.find(params[:id])
    if @article.update(is_approved: true)
      set_records
      flash[:success] = "रचना को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "रचना को स्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def reject
    @article = Article.find(params[:id])
    if @article.update(is_approved: false)
      set_records
      flash[:success] = "रचना को सफलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "रचना को अस्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def destroy
    respond_to do |format|
      if @article.destroy
        set_records
        format.html { redirect_to admin_articles_path, notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया हैै" }
      end
    end
  end

  private

    def set_records
      if params[:articles_category ] == "approved"
        @articles = Article.joins([:author, :context]).approved.order("created_at DESC").page(params[:page])
      elsif params[:articles_category ] == "pending"
        @articles = Article.joins([:author, :context]).pending.order("created_at DESC").page(params[:page])
      elsif params[:articles_category ] == "rejected"
        @articles = Article.joins([:author, :context]).rejected.order("created_at DESC").page(params[:page])
      end
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.fetch(:article, {}).permit(:content, :author_id, :article_type_id,
        :theme_id, :context_id, :hindi_title, :english_title, image_attributes:[:image])
    end

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
end
