class Theme < ApplicationRecord

  has_many :articles
  has_many :contexts
  has_many :theme_chapters
  belongs_to :user

end
