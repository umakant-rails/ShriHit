class StrotaArticle < ApplicationRecord
  belongs_to :strotum
  
  paginates_per 10
end
