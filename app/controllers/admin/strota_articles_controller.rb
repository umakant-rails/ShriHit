class Admin::StrotaArticlesController < ApplicationController
  before_action :set_strota_article, only: %i[ show edit update destroy ]

  # GET /strota_articles or /strota_articles.json
  def index
    @strota_articles = StrotaArticle.order("created_at DESC").page(params[:page])
  end

  # GET /strota_articles/1 or /strota_articles/1.json
  def show
  end

  # GET /strota_articles/new
  def new

    # strotum_id = params[:strota_article][:strotum_id].present? ? params[:strota_article][:strotum_id] : nil
    # article_type_id = params[:strota_article][:article_type_id].present? ? params[:strota_article][:article_type_id] : nil
    # indexx = params[:strota_article][:index].present? ? params[:strota_article][:index] : 0
    @article = StrotaArticle.find(params[:article_id]) rescue nil
    @strota = Strotum.all
    @article_types = ArticleType.all

    if @article.present?
      @strota_article = StrotaArticle.new(
        strotum_id: @article.strotum_id, 
        article_type_id: @article.article_type_id, 
        index: @article.index+1)
    else
      @strota_article = StrotaArticle.new
    end
  end

  # GET /strota_articles/1/edit
  def edit
    @strota = Strotum.all
    @article_types = ArticleType.all
  end

  # POST /strota_articles or /strota_articles.json
  def create
    @strota_article = StrotaArticle.new(strota_article_params)

    respond_to do |format|
      if @strota_article.save
        format.html { redirect_to new_admin_strota_article_url(article_id: @strota_article.id), notice: "Strota article was successfully created." }
        format.json { render :show, status: :created, location: @strota_article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strota_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strota_articles/1 or /strota_articles/1.json
  def update
    respond_to do |format|
      if @strota_article.update(strota_article_params)
        format.html { redirect_to admin_strota_article_url(@strota_article), notice: "Strota article was successfully updated." }
        format.json { render :show, status: :ok, location: @strota_article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strota_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strota_articles/1 or /strota_articles/1.json
  def destroy
    @strota_article.destroy

    respond_to do |format|
      format.html { redirect_to strota_articles_url, notice: "Strota article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strota_article
      @strota_article = StrotaArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strota_article_params
      params.require(:strota_article).permit(:strotum_id, :article_type_id, :index, :content, :interpretation)
    end
end
