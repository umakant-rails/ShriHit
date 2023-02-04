class Admin::AuthorsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_author, only: %i[show edit update destroy mark_as_sant remove_from_sant]
  before_action :create_sampradaya, only: %i[update]
  def index
    @authors = Author.order("created_at DESC").page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to admin_author_url(@author), notice: "रचनाकार को सफलतापूर्वक अद्यतित कर दिया गया है." }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity, error: "रचनाकार को अद्यतित करने की प्रकिया असफल हो गई है" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to admin_authors_url, notice: "रचनाकार को सफलतापूर्वक डिलीट कर दिया गया है." }
      format.json { head :no_content }
    end
  end

  def approved
    @authors_approved = Author.approved.order("created_at DESC").page(params[:page])
  end

  def pending
    set_pending_records
  end

  def approve
    @author = Author.find(params[:id])

    if @author.update(is_approved: true)
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "लेखक को स्वीकृत करने प्रकिया असफल हो गई है"
    end
    respond_to do |format|
      format.html { redirect_to admin_authors_url}
      format.js {}
    end
  end

  def reject
    @author = Author.find(params[:id])
    @unknown_author = Author.where(name: "अज्ञात")
    merge_failed = false

    ActiveRecord::Base.transaction do
      begin
        @author.articles.each do |article|
          article.update!(author_id: @unknown_author.id)
        end
        @author.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    if !merge_failed
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "लेखक को अस्वीकृत करने प्रकिया असफल हो गई है"
    end

    respond_to do |format|
      format.html { redirect_to admin_authors_url}
      format.js {}
    end

  end

  def merge
    @author = Author.find(params[:id])
    @author_merge_in = Author.find(params[:author_merge_in])
    merge_failed = false
    # binding.break
    ActiveRecord::Base.transaction do
      begin
        @author.articles.each do |article|
          article.update!(author_id: @author_merge_in.id)
        end
        @author.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    if !merge_failed
      set_pending_records
      flash[:success] = "लेखक को सफलतापूर्वक विलय कर दिया है"
    else
      flash[:error] = "लेखक को विलय करने प्रकिया असफल हो गई है"
    end
  end

  def mark_as_sant
    respond_to do |format|
      if @author.update({is_saint: true})
        format.html { redirect_to admin_authors_url, notice: "रचनाकार को सफलतापूर्वक संत चिन्हित कर दिया गया है." }
        format.json { render :show, status: :ok, location: @author }
      end
    end
  end

  def remove_from_sant
    respond_to do |format|
      if @author.update({is_saint: false})
        format.html { redirect_to admin_authors_url, notice: "रचनाकार को सफलतापूर्वक चिन्हित संत की सूची से हटा दिया गया है." }
        format.json { render :show, status: :ok, location: @author }
      end
    end
  end

  private

    def set_pending_records
      # if( params[:id].present? )
      #   @authors_pending = Author.where(id: params[:id]).page(params[:page])
      # else
      @authors_pending = Author.pending.order("created_at DESC").page(params[:page])
      # end
      @authors_approved = Author.approved.order("created_at DESC")
    end

    def create_sampradaya
      if params[:author][:sampradaya_id].blank? && params[:sampradaya].present?
        sampradaya = Sampradaya.create(name: params[:sampradaya])
        params[:author][:sampradaya_id] = sampradaya.id
      end
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end

    def author_params
      params.fetch(:author, {}).permit(:name, :sampradaya_id, :biography,
        :birth_date, :death_date, :is_approved)
    end

    def set_author
      @author = Author.find(params[:id]) rescue nil
    end
end
