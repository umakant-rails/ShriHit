class ThemeChapter < ApplicationRecord

  belongs_to :user
  belongs_to :theme
  has_many :theme_articles

end
