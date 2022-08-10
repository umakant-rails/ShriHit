class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :create_author, only: [:create]
  before_action :create_context, only: [:create]

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
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.new(article_params)
    
    respond_to do |format|
      if @article.save
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
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
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
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = current_user.articles.find(params[:id]) rescue nil
      if @article.blank?
        redirect_back_or_to homes_path
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.fetch(:article, {}).permit(:content, :author_id, :article_type_id, 
        :theme_id, :context_id, :hindi_title, :english_title)
    end

    def create_author
      if params[:author_id].blank? && params[:author].present?
        @author = Author.create_author(params[:author], current_user.id)
        params[:article][:author_id] = @author.id 
      end
    end

    def create_context
      if params[:context_id].blank? && params[:context].present?
        @context = Context.create_context(params[:context], current_user.id)
        params[:article][:context_id] = @context.id
      end
    end
end
