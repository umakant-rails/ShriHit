class Article < ApplicationRecord

  belongs_to :author
  belongs_to :context
  belongs_to :user
  belongs_to :article_type
  has_many :theme_articles
  has_many :theme_chapters

  validates :content, :article_type_id, :author_id, :context_id,
    :hindi_title, :english_title, presence: true

  scope :by_author, ->(author_id) { where('author_id = ?', author_id) }
  scope :by_context, ->(context_id) { where('context_id = ?', context_id) }
  scope :by_article_type, ->(article_type_id) { where('article_type_id = ?', article_type_id) }
  scope :by_id, ->(id){ where("articles.id = ? ", id)}
  scope :by_search_term, ->(term) {where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
      "%#{term.downcase}%", "%#{term.downcase}%")}

  # Scope for Article and ThemeArticle join operation
  scope :_theme_articles, ->(theme_id){
    where({theme_articles: {theme_id: theme_id}})
  }
  # Scope for Article and ThemeChapter join operation
  scope :_chapter_articles, ->(theme_chapter_id) { 
    where({theme_articles: {theme_chapter_id: theme_chapter_id}})
  }

  scope :_except_theme_articles, -> (theme_id) {
    where.not(id: ThemeArticle.where(theme_id: theme_id).pluck(:id))
  }
  scope :_except_chapter_articles, -> (theme_chapter_id) {
    where.not(id: ThemeArticle.where(theme_chapter_id: theme_chapter_id).pluck(:article_id))
  }

  def self.by_attributes(author_id, context_id, article_type_id, selected_chapter_id)
    query = ""
    if author_id.present?
      query += "author_id = #{author_id}"
    end
    if context_id.present?
      query += query.blank? ? "context_id = #{context_id}" : " and context_id = #{context_id}"
    end
    if article_type_id.present?
      query += query.blank? ? "article_type_id = #{article_type_id}" : " and article_type_id = #{article_type_id}"
    end
    return self.where(query) #._except_chapter_articles(selected_chapter_id) #where("theme_chapter_id is null or theme_chapter_id != ?", selected_chapter_id)
  end

end
