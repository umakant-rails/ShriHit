class Admin::StrotaController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_strotum, only: %i[ show edit update destroy ]

  # GET /strota or /strota.json
  def index
    @strota = Strotum.order("updated_at DESC").page(params[:page])
  end

  # GET /strota/1 or /strota/1.json
  def show
  end

  # GET /strota/new
  def new
    @strota_types = StrotaType.all
    @strotum = Strotum.new
  end

  # GET /strota/1/edit
  def edit
    @strota_types = StrotaType.all
  end

  # POST /strota or /strota.json
  def create
    @strotum = Strotum.new(strotum_params)

    respond_to do |format|
      if @strotum.save
        format.html { redirect_to admin_strota_url, notice: "Strotum was successfully created." }
        format.json { render :show, status: :created, location: @strotum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strota/1 or /strota/1.json
  def update
    respond_to do |format|
      if @strotum.update(strotum_params)
        format.html { redirect_to admin_strota_url, notice: "Strotum was successfully updated." }
        format.json { render :show, status: :ok, location: @strotum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strota/1 or /strota/1.json
  def destroy
    @strotum.destroy

    respond_to do |format|
      format.html { redirect_to admin_strota_url, notice: "Strotum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strotum
      @strotum = Strotum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strotum_params
      params.require(:strotum).permit(:title, :source, :strota_type_id, :keyword)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end
end
