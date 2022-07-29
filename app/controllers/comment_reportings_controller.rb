class CommentReportingsController < ApplicationController
  before_action :authenticate_user!

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

  private

    def comment_reporting_params
       params.fetch(:comment_reporting, {}).permit(:report_msg, :article_id, :user_id, 
        :comment_id)
    end

end
