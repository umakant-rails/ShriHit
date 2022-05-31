module ApplicationHelper

  def show_collapse_items(controller)
    if params[:controller] == "theme_chapters"
      return controller == "themes" ? 'show' : nil
    else
      return (controller == params[:controller]) ? 'show' : nil
    end
  end

  def set_active(controller, action)
    if params[:action] == "new" && action == "new"
      return controller == params[:controller] ? 'active' : nil
    elsif params[:action] != "new" && action == "others"
      return (controller == params[:controller]) ? 'active' : nil
    end
  end

end
