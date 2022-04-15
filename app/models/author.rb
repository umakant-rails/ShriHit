class Author < ApplicationRecord

  has_many :articles
  belongs_to :user
  belongs_to :sampradaya
  
  validates :name, presence: true

  def self.create_author(name)
    author = self.where(name: name).first
    return (author.present? ? author : self.create(name: name))
  end
  
end
