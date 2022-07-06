class ApplicationController < ActionController::Base
	layout :set_layouts
	before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_required_data, if: :devise_controller?

  private

  def set_required_data
    @article_types = ArticleType.order("name ASC")
    @contexts = Context.order("name ASC")
    @authors = Author.order("name ASC")
    @contributors = User.order("username ASC")
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
