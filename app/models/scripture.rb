class Scripture < ApplicationRecord

  belongs_to :user
  has_many :chapters
  has_many :sections

  validates :name, :author, :size, presence: true

end
