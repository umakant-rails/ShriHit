class Theme < ApplicationRecord

  has_many :articles
  has_many :contexts, dependent: :nullify
  has_many :theme_chapters, dependent: :destroy
  has_many :theme_articles, dependent: :destroy
  belongs_to :user

  validates :name, presence: true

end
