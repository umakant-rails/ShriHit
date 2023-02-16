class Admin::ContextsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @contexts = Context.order("created_at DESC").page(params[:page])
  end

  def approved
    @contexts_approved = Context.approved.order("created_at DESC").page(params[:page])
  end

  def pending
    set_pending_records
  end

  def approve
    @context = Context.find(params[:id])
    if @context.update!(is_approved: true)
      set_pending_records
      flash[:success] = "प्रसंग को सफलतापूर्वक स्वीकृत कर दिया है"
    else
      flash[:error] = "प्रसंग को स्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def reject
    @context = Context.find(params[:id])
    @misc_context = Context.where(name: "विविध")
    merge_failed = false

    ActiveRecord::Base.transaction do
      begin
        @context.articles.each do |article|
          article.update!(context_id: @misc_context.id)
        end
        @context.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    if !merge_failed
      set_pending_records
      #redirect_to action: 'pending_contexts'
      flash[:success] = "प्रसंग को सफलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "प्रसंग को अस्वीकृत करने प्रकिया असफल हो गई है"
    end
  end

  def merge
    @context = Context.find(params[:id])
    @old_context = Context.find(params[:context_merge_in])
    merge_failed = false

    ActiveRecord::Base.transaction do
      begin
        @context.articles.each do |article|
          article.update!(context_id: @old_context.id)
        end
        @context.destroy!
      rescue ActiveRecord::StatementInvalid
        merge_failed = true
      end
    end

    
    if !merge_failed 
      set_pending_records
      #redirect_to action: 'pending_contexts'
      flash[:success] = "प्रसंग को सफलतापूर्वक विलय कर दिया है"
    else
      flash[:error] = "प्रसंग को विलय करने प्रकिया असफल हो गई है"
    end
  end

  def update
    @context = Context.find(params[:id])
    if @context.update(name: params[:updated_name], is_approved: true)
      #redirect_to action: 'pending_contexts'
      set_pending_records
      flash[:success] = "प्रसंग का नाम सफलतापूर्वक बदल दिया गया है"
    else
      flash[:error] = "प्रसंग का नाम बदलने की प्रकिया असफल हो गई है"
    end
  end
 
  def report
    @articles_by_context = Context.joins(:articles).group(:name).count
    @approved_articles = Context.joins(:articles).where(articles: {is_approved: true}).group(:name).count
    @pending_articles = Context.joins(:articles).where(articles: {is_approved: nil}).group(:name).count
  end

  private

    def set_pending_records
      if( params[:id].present? )
        @contexts_pending = Context.where(id: params[:id]).page(params[:page])
      else
        @contexts_pending = Context.pending.order("created_at DESC").page(params[:page])
      end
      @contexts_approved = Context.approved.order("created_at DESC")
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end

end