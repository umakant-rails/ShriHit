module ApplicationHelper

  def show_admin_collapse_items(admin_action)
    if ["admin/contexts", "admin/authors", "admin/articles"].index(params[:controller]) != nil
      return params[:controller].index("admin") != nil && (admin_action == params[:action]) ? "show" : nil
    end
  end
  
  def set_admin_lnk_active(controller, action)
    if controller == params[:controller] && action == params[:action]
      return "active"
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
