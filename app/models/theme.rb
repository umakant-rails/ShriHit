class Theme < ApplicationRecord

  has_many :articles
  has_many :contexts
  belongs_to :user

end
