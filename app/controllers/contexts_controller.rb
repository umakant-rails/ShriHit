class ContextsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_context, only: %i[ show edit update destroy ]

  # GET /contexts or /contexts.json
  def index
    @contexts = Context.order("created_at DESC").page(params[:page])
  end

  # GET /contexts/1 or /contexts/1.json
  def show
  end

  # GET /contexts/new
  def new
    @context = Context.new(is_approved: true)
  end

  # GET /contexts/1/edit
  def edit
  end

  # POST /contexts or /contexts.json
  def create
    params[:context][:name] = params[:context][:name].strip
    @context = current_user.contexts.new(context_params)

    respond_to do |format|
      if @context.save
        format.html { redirect_to contexts_url(), notice: "Context was successfully created." }
        format.json { render :show, status: :created, location: @context }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contexts/1 or /contexts/1.json
  def update
    respond_to do |format|
      if @context.update(context_params)
        format.html { redirect_to contexts_url(), notice: "Context was successfully updated." }
        format.json { render :show, status: :ok, location: @context }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contexts/1 or /contexts/1.json
  def destroy
    @context.destroy

    respond_to do |format|
      format.html { redirect_to contexts_url, notice: "Context was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @context = Context.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def context_params
      params.fetch(:context, {}).permit(:name, :is_approved, :user_id)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
