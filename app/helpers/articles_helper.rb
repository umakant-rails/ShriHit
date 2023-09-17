module ArticlesHelper

  def article_type_hash
    arr = []
    article_types = ArticleType.all
    article_types.each do |element|
      arr<<[element.name, element.id]
    end
    return arr
  end

  def get_data_for_article_creation(current_user)
    article_types = ArticleType.order("name ASC").collect{|e| [e.name, e.id]}
    authors = Author.where("is_approved = ? or user_id = ?", true, current_user.id)
      .order("name ASC").collect{|e| ["#{e.name_eng} (#{e.name})", e.id]}
    contexts = Context.where("is_approved = ? or user_id = ?", true, current_user.id)
      .order("name ASC").collect{|e| [e.name, e.id]}
    raags = Raag.all.collect{|r| ["#{r.name_eng.camelize} (#{r.name})", r.id]}
    scriptures = ScriptureType.find_by_name("रसिक वाणी").scriptures.collect{|s|["#{s.name_eng.camelize} (#{s.name})", s.id]}
    # contexts.push(['प्रसंग का नाम टाइप करे', 'NA'])
    # authors.push(['लेखक का नाम टाइप करे', 'NA'])
    return article_types, authors, contexts, raags, scriptures
  end
end
