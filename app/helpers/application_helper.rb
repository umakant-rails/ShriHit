module ApplicationHelper

  def set_active(path_params, path_string)
    if (path_params == path_string)
      return "active"
    elsif !path_params.index('new') && path_params.index(path_string) != nil
      return "active"
    end
  end

end
