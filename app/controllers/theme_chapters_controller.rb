class ThemeChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_theme_chapter, only: %i[ show edit update destroy ]

  def index
    @theme_chapters = current_user.theme_chapters.page(params[:page]) 
  end

  def new
    @themes = current_user.themes
    @theme_chapter = ThemeChapter.new(is_default: false)
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

  def edit
  end
  
  def update
    respond_to do |format|
      if @theme_chapter.update(theme_chapter_params)
        format.html { redirect_to theme_chapter_url(@theme_chapter), notice: "Theme Chapter was successfully updated." }
        format.json { render :show, status: :ok, location: @theme_chapter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @theme_chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @theme_chapter.destroy

    respond_to do |format|
      format.html { redirect_to theme_chapters_url, notice: "Theme Chapter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_theme_chapter
      @theme_chapter = current_user.theme_chapters.find(params[:id]) rescue nil
      if @theme_chapter.blank?
        redirect_back_or_to homes_path
      end
    end

    # Only allow a list of trusted parameters through.
    def theme_chapter_params
      params.fetch(:theme_chapter, {}).permit(:name, :theme_id, :is_default)
    end

end
