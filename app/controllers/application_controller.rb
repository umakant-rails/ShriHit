class ApplicationController < ActionController::Base
	layout :set_layouts
	before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_public_data, if: :is_user_not_present?
  before_action :set_admin_data, if: :is_user_admin_or_super_admin?
  private

  def set_public_data
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @contributors = User.order("username ASC")
  end

  def set_admin_data
    @notifications = []

    @contexts_pending = Context.pending
    @authors_pending = Author.pending
    @articles_pending = Article.pending

    @contexts_new = Context.where("created_at > ? ", current_user.last_sign_in_at)
    @authors_new  = Author.where("created_at > ? ", current_user.last_sign_in_at)
    @articles_new = Article.where("created_at > ? ", current_user.last_sign_in_at)

    @notifications.push({key1: "रचनायें", key2: "#{@articles_pending.length} रचनायें स्वीकृत हेतु लंबित है"}) if @articles_pending.present?
    @notifications.push({key1: "रचनायें", key2: "#{@articles_new.length} नई रचनायें दर्ज की गई है"}) if @articles_new.present?
    @notifications.push({key1: "प्रसंग", key2: "#{@contexts_pending.length} प्रसंग स्वीकृत हेतु लंबित है"}) if @contexts_pending.present?
    @notifications.push({key1: "प्रसंग", key2: "#{@contexts_new.length} नए प्रसंग दर्ज किये गए है"}) if @contexts_new.present?
    @notifications.push({key1: "रचनाकार", key2: "#{@authors_pending.length} रचनाकार स्वीकृत हेतु लंबित है"}) if @authors_pending.present?
    @notifications.push({key1: "रचनाकार", key2: "#{@authors_new.length} नए रचनाकार दर्ज किये गए है"}) if @authors_new.present?
  end

  def is_user_not_present?
    return current_user.blank?
  end

  def is_user_admin_or_super_admin?
    return current_user && (current_user.is_admin || current_user.is_super_admin)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, 
      :username, :role_id, :email])
  end

  def after_sign_in_path_for(resource)
    if resource.present? && (resource.role_id == 1)
      homes_path
    else
      homes_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
	  new_user_session_path
	end

	def set_layouts
    if current_user.present?
      return 'user'
    elsif current_user.present?
      return 'user'
    else
      return 'application'
    end
  end

end
