module ApplicationHelper

  def set_active(path_params, path_string)
    if (path_params == path_string)
      return "active"
    elsif !path_params.index('new') && path_params.index(path_string) != nil
      return "active"
    end
  end

  def show_collapse_item(path_params, path_string1, path_string2, path_string3=nil, path_string4=nil)
    result1 = set_active(path_params, path_string1)
    result2 = set_active(path_params, path_string2)

    result3 = path_string3.blank? ? nil :  set_active(path_params, path_string3)
    result4 = path_string4.blank? ? nil :  set_active(path_params, path_string4)


    if [result1, result2, result3, result4].index("active") != nil # (result1 == "active") || (result2 == "active")
      return "show"
    end
  end

end
