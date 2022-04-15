class Author < ApplicationRecord

  has_many :articles
  belongs_to :user
  belongs_to :sampradaya, optional: true

  validates :name, presence: true

  def self.create_author(name, user_id)
    author = self.where(name: name).first
    return (author.present? ? author : self.create!(name: name, user_id: user_id))
  end
  
end
