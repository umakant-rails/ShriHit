class Admin::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_section, only: %i[ show edit update destroy ]

  # GET /sections or /sections.json
  def index
    @sections = Section.order("title ASC").page(params[:page])
  end

  # GET /sections/1 or /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @scriptures = current_user.scriptures
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
    @scriptures = current_user.scriptures
  end

  # POST /sections or /sections.json
  def create
    @section = Section.new(section_params)
    @scriptures = current_user.scriptures
    
    respond_to do |format|
      if @section.save
        format.html { redirect_to admin_sections_url, notice: "Section was successfully created." }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to admin_section_url(@section), notice: "Section was successfully updated." }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section.destroy

    respond_to do |format|
      format.html { redirect_to admin_sections_url, notice: "Section was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.fetch(:section, {}).permit(:title, :description, :scripture_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
