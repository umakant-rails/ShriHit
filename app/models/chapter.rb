class Chapter < ApplicationRecord

  # belongs_to :scripture
  belongs_to :section
  has_many :scripture_articles
  validates :title, presence: true

  paginates_per 10

end
