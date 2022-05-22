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
  scope :by_search_english_term, ->(term) {where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
      "%#{term.downcase}%", "%#{term.downcase}%")}
  scope :by_search_hindi_term, ->(term) {where("content like ? ", "%#{term.strip}%")}


  def self.by_attributes(author_id, context_id, article_type_id, selected_chapter_id, contributor_id)
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
    if contributor_id.present?
      query += query.blank? ? "user_id = #{contributor_id}" : " and user_id = #{contributor_id}"
    end
    return Article.where(query) #._except_chapter_articles(selected_chapter_id) #where("theme_chapter_id is null or theme_chapter_id != ?", selected_chapter_id)
  end

  def self.theme_chapters(theme_chapter_id)
    ThemeArticle.joins(:article).where({theme_articles: {theme_chapter_id: theme_chapter_id}})
  end

  def self.get_articles_by_params(params)
    articles, added_articles = [], []
    if params[:search_type] == 'by_attribute'
      articles = self.by_attributes(params[:author_id], params[:context_id], 
        params[:article_type_id], params[:theme_chapter_id], params[:contributor_id]
      )
    elsif params[:search_type] == 'by_id'
      articles = Article.by_id(params[:article_id])
    elsif params[:search_type] == 'by_term'
      search_term = params[:term]
      if params[:search_in] == "english"
        articles = Article.by_search_english_term(search_term)
      else
        articles = Article.by_search_hindi_term(search_term)
      end
    else
      articles = Article.order("created_at desc")
    end

    added_articles = Article.theme_chapters(params[:theme_chapter_id]) if params[:theme_chapter_id].present?
    #articles = @articles._except_chapter_articles(params[:theme_chapter_id])
    articles = articles.where.not(id: added_articles.pluck(:article_id))
    return added_articles, articles
  end
end
