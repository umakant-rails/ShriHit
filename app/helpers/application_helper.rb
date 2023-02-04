module ApplicationHelper

  def show_admin_collapse_items
    if ["admin/authors", "admin/articles", "admin/tags"].index(params[:controller])
      return "show"
    end
  end

  def set_admin_lnk_active(controller)
    if params[:controller] == controller
      return "active"
    else
      return ""
    end
  end

  def show_reports_items(controller, action)
    if controller.present? && action.blank?
      return (controller == params[:controller]) ? "down" : "right"
    elsif controller.blank? && action.present?
      (action == params[:action]) ? "active" : ""
    end
  end

  def show_collapse_items(controller)
    if params[:controller] == "theme_chapters"
      return controller == "themes" ? "show" : nil
    else
      return (controller == params[:controller]) ? "show" : nil
    end
  end

  def set_active(controller, action)
    if params[:action] == "new" && action == "new"
      return controller == params[:controller] ? "active" : nil
    elsif params[:action] != "new" && action == "others"
      return (controller == params[:controller]) ? "active" : nil
    end
  end

  def get_pending_link(model_name)
    if(model_name == "Article")
      return pending_articles_admin_articles_path
    elsif (model_name == "Context")
      return pending_contexts_admin_contexts_path
    elsif (model_name == "Author")
      return pending_authors_admin_authors_path
    end
  end

end
