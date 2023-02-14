class SaintBioEventsController < ApplicationController
  before_action :set_saint_bio_event, only: %i[ show edit update destroy ]

  # GET /saint_bio_events or /saint_bio_events.json
  def index
    @saint_bio_events = SaintBioEvent.all
  end

  # GET /saint_bio_events/1 or /saint_bio_events/1.json
  def show
  end

  # GET /saint_bio_events/new
  def new
    @sants = Author.where(is_saint:true).collect { |a| [a.name, a.id]}
    @saint_bio_event = SaintBioEvent.new
  end

  # GET /saint_bio_events/1/edit
  def edit
    @sants = Author.where(is_saint:true).collect { |a| [a.name, a.id]}
  end

  # POST /saint_bio_events or /saint_bio_events.json
  def create
    @saint_bio_event = current_user.saint_bio_events.new(saint_bio_event_params)

    respond_to do |format|
      if @saint_bio_event.save
        format.html { redirect_to saint_bio_event_url(@saint_bio_event), notice: "Saint bio event was successfully created." }
        format.json { render :show, status: :created, location: @saint_bio_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @saint_bio_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saint_bio_events/1 or /saint_bio_events/1.json
  def update
    respond_to do |format|
      if @saint_bio_event.update(saint_bio_event_params)
        format.html { redirect_to saint_bio_event_url(@saint_bio_event), notice: "Saint bio event was successfully updated." }
        format.json { render :show, status: :ok, location: @saint_bio_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @saint_bio_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saint_bio_events/1 or /saint_bio_events/1.json
  def destroy
    @saint_bio_event.destroy

    respond_to do |format|
      format.html { redirect_to saint_bio_events_url, notice: "Saint bio event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saint_bio_event
      @saint_bio_event = SaintBioEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def saint_bio_event_params
      params.require(:saint_bio_event).permit(:title, :event, :user_id, :author_id)
    end
end
