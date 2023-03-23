class Admin::ChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_chapter, only: %i[ show edit update destroy ]

  def index
    @chapters = Chapter.chapters.order("name ASC").page(params[:page])
  end

  def new
    if params[:scripture_id].present?
      @scriptures = current_user.scriptures.where(category: 3)
    else
      @scriptures = current_user.scriptures.where("category > ?", 1)
    end
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @scriptures = current_user.scriptures

    respond_to do |format|
      if @chapter.save
        if @chapter.is_section == true
          format.html { redirect_to admin_scripture_path(@chapter.scripture.id) }
        else
          format.html { redirect_to admin_chapters_url(is_section: params[:is_section]), notice: "अध्याय को सफलतापूर्वक बना दिया गया है |" }
        end
        format.json { render :show, status: :created, location: @chapter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    @scriptures = current_user.scriptures
    @scripture = @chapter.scripture
    @sections = @scripture.sections
  end

  def update

    respond_to do |format|
      if @chapter.update(chapter_params)
        if @chapter.is_section == true
          format.html { redirect_to admin_scripture_path(@chapter.scripture.id) }
        else
          format.html { redirect_to admin_chapters_url, notice: "अध्याय को सफलतापूर्वक अद्यतित कर दिया गया है |" }
        end
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    is_section = @chapter.is_section
    @chapter.destroy

    respond_to do |format|
      if is_section == true
        format.html { redirect_to admin_scripture_path(@chapter.scripture.id) }
      else
        format.html { redirect_to admin_chapters_url, notice: "अध्याय को सफलतापूर्वक को डिलीट कर दिया गया है | " }
      end

      format.json { head :no_content }
    end
  end

  def get_sections
    @scripture = current_user.scriptures.find(params[:scripture_id])
    @sections = @scripture.sections
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.fetch(:chapter, {}).permit(:name, :is_section, :parent_id, :scripture_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
