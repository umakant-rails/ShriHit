class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy ]

  def new 
  end

  def create
    @comment = current_user.comments.new(comment_params)
    parent_name = params[:parent_name]

    if(params[:parent_name] == "Article") 
      @article = @parent = Article.find(params[:parent_id])
    elsif(params[:parent_name] == "Comment")
      @parent = Comment.find(params[:parent_id])
      @article = @parent.commentable
    end
    @comment.commentable = @parent

    respond_to do |format|
      if @comment.save
        format.js {}
        format.json { render :show, status: :ok, location: @comment }
      else
        format.js {}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash[:success] = "Comment was successfully updated." 
        format.js {}
        format.json { render :show, status: :ok, location: @article }
      else
        format.js { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        flash[:success] = "Comment was successfully deleted." 
        format.js {}
      end
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.fetch(:comment, {}).permit(:comment, :user_id)
    end

end
