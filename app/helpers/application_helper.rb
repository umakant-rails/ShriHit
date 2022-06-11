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

end
