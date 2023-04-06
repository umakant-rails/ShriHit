class Admin::ChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_chapter, only: %i[ show edit update destroy ]

  def index
    @chapters = Chapter.chapters.order("name ASC").page(params[:page])
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
        if @chapter.is_section == true
          format.html { redirect_to admin_scripture_path(@chapter.scripture.id) }
        else
          format.html { redirect_to admin_chapters_url(is_section: params[:is_section]), notice: "अध्याय को सफलतापूर्वक बना दिया गया है |" }
        end
        format.json { render :show, status: :created, location: @chapter }
      else
        params[:scripture_id] = params[:chapter][:scripture_id]
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
  
  def add_section_chapters
    @scriptures = Scripture.all
  end

  def remove_section_chapters
    @scriptures = Scripture.all
  end

  def get_sections
    @scripture = current_user.scriptures.find(params[:scripture_id]) rescue nil
    @sections = @scripture.sections rescue nil
    @chapters = @scripture.chapters.where("is_section is false and parent_id is null") rescue nil
  end

  def get_section_chapters
    @section = Chapter.find(params[:section_id])
    @chapters = @section.chapters
  end

  def add_chapters_in_section
    Chapter.where("id in (?)", params[:chapters]).update(parent_id: params[:section_id])
    @scripture = Scripture.find(params[:scripture_id])
    @chapters = @scripture.chapters.where("is_section is false and parent_id is null")
  end

  def remove_chapters_from_section
    Chapter.where("id in (?)", params[:chapters]).update(parent_id: nil)
    @section = Chapter.find(params[:section_id]) rescue nil
    @chapters = @section.chapters rescue nil
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
