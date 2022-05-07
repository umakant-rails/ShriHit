module ThemeChaptersHelper

  def get_themes_hash
    themes = current_user.themes.all.collect{|e| [e.name, e.id]}
    return themes
  end

end
