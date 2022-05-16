class Theme < ApplicationRecord

  has_many :articles
  has_many :contexts
  has_many :theme_chapters
  has_many :theme_articles
  belongs_to :user

end
