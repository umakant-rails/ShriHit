class Theme < ApplicationRecord
  has_many :articles
  has_many :contexts
end
