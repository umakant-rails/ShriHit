class Public::SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.order("created_at DESC").page(params[:page])
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    if current_user.present?
      @suggestion = current_user.suggestions.new(suggestion_params)
      @suggestion.email = current_user.email
      @suggestion.username = current_user.username
    else 
      @suggestion = Suggestion.new(suggestion_params)
    end

    respond_to do |format|
      if @suggestion.save
        format.html { redirect_to public_suggestion_url(@suggestion), notice: "Suggestion was successfully created." }
        format.json { render :show, status: :created, location: @suggestion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  private

    def suggestion_params
      params.fetch(:suggestion, {}).permit(:email, :username, :title, :description, :user_id)
    end

end
