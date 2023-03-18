class Section < ApplicationRecord

  belongs_to :scripture
  has_many :scripture_articles

  paginates_per 10

end
