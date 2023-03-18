class Chapter < ApplicationRecord

  # belongs_to :scripture
  belongs_to :section
  has_many :scripture_articles
end
