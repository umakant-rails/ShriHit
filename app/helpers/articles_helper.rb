module ArticlesHelper

  def article_type_hash
    arr = []
    article_types = ArticleType.all
    article_types.each do |element|
      arr<<[element.name, element.id]
    end
    return arr
  end

end
