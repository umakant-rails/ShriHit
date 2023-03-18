class Admin::ChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_chapter, only: %i[ show edit update destroy ]

  def index
    @chapters = Chapter.order("title ASC").page(params[:page])
  end

  def new
    @scriptures = current_user.scriptures
    @chapter = Chapter.new
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @scriptures = current_user.scriptures
    
    respond_to do |format|
      if @chapter.save
        format.html { redirect_to admin_chapters_url, notice: "अध्याय को सफलतापूर्वक बना दिया गया है |" }
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
    scripture_id = @section_chapter.section.scripture_id
    @sections = Scripture.find(scripture_id).sections
  end

  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to admin_chapters_url, notice: "अध्याय को सफलतापूर्वक अद्यतित कर दिया गया है |" }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chapter.destroy

    respond_to do |format|
      format.html { redirect_to admin_chapters_url, notice: "अध्याय को सफलतापूर्वक को डिलीट कर दिया गया है | " }
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
      params.fetch(:chapter, {}).permit(:title, :section_id, :scripture_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
