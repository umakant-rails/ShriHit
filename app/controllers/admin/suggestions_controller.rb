class Admin::SuggestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_suggestion, only: %i[ approve reject ]

  def index
    @suggestions = Suggestion.where(is_approved: nil).page(params[:page]).per(10)
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def rejected
    @suggestions = Suggestion.where(is_approved: false).page(params[:page]).per(10)
  end

  def approved
    @suggestions = Suggestion.where(is_approved: true).page(params[:page]).per(10)
  end

  def approve
    @suggestion.update(is_approved: true)
    respond_to do |format|
      format.html { redirect_to admin_suggestions_url, notice: "Suggestion was successfully approved." }
      format.json { head :no_content }
    end
  end

  def reject
    @suggestion.update(is_approved: false)
    respond_to do |format|
      format.html { redirect_to admin_suggestions_url, notice: "Suggestion was successfully rejected  ." }
      format.json { head :no_content }
    end
  end

  private

    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end
end
