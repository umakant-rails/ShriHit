module Public::StrotaHelper
  
  def get_strota_content(content, indx)
    indexing1 = "॥#{(indx+1).to_s}॥"
    indexing2 = "।।#{(indx+1).to_s}।।"

    if content.index(indexing1).blank? and content.index("॥").present?
      content.gsub("॥", indexing1)
    elsif content.index(indexing2).blank? and content.index("।।").present?
      content.gsub("।।", indexing2)
    else 
      content
    end
  end

end
