class Section < ApplicationRecord

  belongs_to :scripture
  has_many :scripture_articles

  validates :title, presence: true

  paginates_per 10

end
