class Admin::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :set_tag, only: %i[approve reject convert_tag_to_context]
  def index
    @tags = Tag.order("created_at DESC").page(params[:page])
  end

  def approve
    if @tag.update(is_approved: true)
      flash[:success] = "टैग को फलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "टैग को स्वीकृत करने की प्रकिया असफल हो गई है"
    end
    get_rejected_tags
  end

  def reject
    if @tag.update(is_approved: false)
      flash[:success] = "टैग को सफलतापूर्वक अस्वीकृत कर दिया है"
    else
      flash[:error] = "टैग को अस्वीकृत करने की प्रकिया असफल हो गई है"
    end
    get_approved_tags
  end

  def convert_tag_to_context
    if Context.where(name: @tag.name).blank?
      context = Context.new(name: @tag.name, is_approved: true, user_id: @tag.user_id)
      if context.save
        @tag.update(is_approved: true, is_imported_as_tag: true)
        flash[:success] = "टैग को सफलतापूर्वक प्रसंग बना दिया गया हैै"
      else
        flash[:error] = "टैग को प्रसंग बनाने की प्रकिया असफल हो गई हैै"
      end
    else
      flash[:error] = "इस टैग को पहले से प्रसंग बना दिया गया हैै"
    end
    get_approved_tags
  end

  def approved
    get_approved_tags
  end

  def rejected
    get_rejected_tags
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def get_approved_tags
      @tags = Tag.approved.order("created_at DESC").page(params[:page])
    end

    def get_rejected_tags
      @tags = Tag.pending.order("created_at DESC").page(params[:page])
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_to new_user_session_path
      end
    end

end
