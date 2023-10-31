module Public::StrotaHelper
  
  def get_strota_content(content, indx=nil)
    indexing1 = "॥#{(indx+1).to_s}॥"
    indexing2 = "।।#{(indx+1).to_s}।।"

    if indx.present? && content.index(indexing1).blank? and content.index("॥").present?
      content.gsub("॥", indexing1)
    elsif indx.present? && content.index(indexing2).blank? and content.index("।।").present?
      content.gsub("।।", indexing2)
    else 
      content
    end
  end

end
