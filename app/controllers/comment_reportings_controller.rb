class CommentReportingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment_reporting, only: %i[:destroy]

  def index
    @comments = Comment.joins(:comment_reportings).not_read.uniq
  end

  def create
    @comment_reporting = current_user.comment_reportings.new(comment_reporting_params)

    respond_to do |format|
      if @comment_reporting.save
        format.html { redirect_to article_url(@comment_reporting), notice: "Comment Report submitted successfully." }
        format.json { render :show, status: :created, location: @comment_reporting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment_reporting.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_read

    @comment = Comment.find(params[:comment_id])
    @comment.comment_reportings.update_all(is_read: true)
    # each do | comment_reporting | 
    #   comment_reporting.update(is_read: true)
    # end
    @comments = Comment.joins(:comment_reportings).not_read.uniq
    respond_to do |format|
      format.html { redirect_to comment_reportings_url, notice: "Report comment as Spam was successfully destroyed." }
      format.js {}
    end
  end

  def destroy
    @comment_reporting.destroy

    respond_to do |format|
      format.html { redirect_to comment_reportings_url, notice: "Report comment as Spam was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_comment_reporting
      @comment_reporting = CommentReporting.find(params[:id])
    end

    def comment_reporting_params
       params.fetch(:comment_reporting, {}).permit(:report_msg, :article_id, :user_id, 
        :comment_id)
    end

end
