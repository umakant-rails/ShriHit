class Article < ApplicationRecord

  belongs_to :author
  belongs_to :context
  belongs_to :user
  belongs_to :article_type

  validates :content, :article_type_id, :author_id, :context_id,
    :hindi_title, :english_title, presence: true

end
