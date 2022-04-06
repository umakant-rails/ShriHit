module ArticlesHelper

  def article_type_hash
    arr = []
    article_types = ArticleType.all
    article_types.each do |element|
      arr<<[element.name, element.id]
    end
    return arr
  end
  def get_data_for_article_creation
    article_types = ArticleType.all.collect{|e| [e.name, e.id]}
    themes = Theme.all.collect{|e| [e.name, e.id]}
    writers = Writer.all.collect{|e| [e.name, e.id]}
    contexts = Context.all.collect{|e| [e.name, e.id]}
    writers.push(['प्रसंग का नाम टाइप करे', 'NA'])
    contexts.push(['लेखक का नाम टाइप करे', 'NA'])
    return article_types, themes, writers, contexts
  end
end
