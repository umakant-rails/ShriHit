class Scripture < ApplicationRecord

  belongs_to :user
  belongs_to :scripture_type
  belongs_to :author
  belongs_to :sampradaya, optional: true
  has_many :chapters, -> { chapter_scope }, dependent: :destroy
  has_many :sections, -> { section_scope }, foreign_key: 'scripture_id', class_name: 'Chapter'
  has_many :scripture_articles, dependent: :destroy 
  has_many :stories


  validates :name, presence: true

  CATEGORIES = [['लघु', 1],['मध्यम', 2],['वृहद', 3]]

end
