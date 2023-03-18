class Section < ApplicationRecord

  belgons_to :scripture
  has_many :scripture_articles

end
