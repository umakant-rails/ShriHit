class AuthorsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :create_sampradaya, only: %i[create update]
  def index
    @authors = current_user.authors.page(params[:page])
  end

  def new
    @author = Author.new
  end

  def show
  end

  def create
    params[:author][:name] = params[:author][:name].strip
    @author = current_user.authors.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to author_url(@author), notice: "Author was successfully created." }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to author_url(@author), notice: "Author was successfully updated." }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @author.destroy

    respond_to do |format|
      format.html { redirect_to authors_url, notice: "Author was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def autocomplete_term
    search_term = params[:q].strip

    @authors = Author.where("LOWER(name_eng) like ? ", "%#{search_term.downcase}%")

    respond_to do |format|
      format.html {}
      format.json { head :no_content }
    end
    render layout: false
  end

  private

    def set_author
      @author = current_user.authors.find(params[:id]) rescue nil
      if @author.blank?
        redirect_back_or_to homes_path
      end
    end

    def author_params
      params.fetch(:author, {}).permit(:name, :name_eng, :sampradaya_id, :biography,
        :birth_date, :death_date, :is_approved)
    end

    def create_sampradaya
      if params[:author][:sampradaya_id].blank? && params[:sampradaya].present?
        sampradaya = Sampradaya.create(name: params[:sampradaya])
        params[:author][:sampradaya_id] = sampradaya.id
      end
    end

end
