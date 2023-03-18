class ScriptureArticle < ApplicationRecord
  
  belongs_to :user
  belongs_to :section
  belongs_to :chapter, optional: true

end
