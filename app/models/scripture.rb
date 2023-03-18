class Scripture < ApplicationRecord

  belongs_to :user
  belongs_to :scripture_type
  has_many :chapters
  has_many :sections

  validates :name, :author, :size, presence: true

end
