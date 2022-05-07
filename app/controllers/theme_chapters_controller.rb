class ThemeChaptersController < ApplicationController
  before_action :set_theme_chapter, only: %i[ show edit update destroy ]

  def index
    @theme_chapters = current_user.theme_chapters 
  end

  def new
    @themes = current_user.themes
    @theme_chapter = ThemeChapter.new
  end

  def create
    @theme_chapter = current_user.theme_chapters.new(theme_chapter_params)

    respond_to do |format|
      if @theme_chapter.save
        format.html { redirect_to theme_chapter_url(@theme_chapter), notice: "Theme Chapter was successfully created." }
        format.json { render :show, status: :created, location: @theme_chapter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @theme_chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme_chapter
      @theme_chapter = ThemeChapter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def theme_chapter_params
      params.fetch(:theme_chapter, {}).permit(:name, :theme_id)
    end

end
