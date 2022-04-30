module ApplicationHelper

  def set_active(path_params, path_string)
    if (path_params == path_string)
      return "active"
    elsif !path_params.index('new') && path_params.index(path_string) != nil
      return "active"
    end
  end

  def show_collapse_item(path_params, path_string1, path_string2)
    result1 = set_active(path_params, path_string1)
    result2 = set_active(path_params, path_string2)
    if (result1 == "active") || (result2 == "active")
      return "show"
    end
  end

end
