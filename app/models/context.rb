class Context < ApplicationRecord
  has_many :articles
  belongs_to :theme, optional: true
  belongs_to :user, optional: true

  scope :pending, ->() { where(is_approved: false) }
  scope :approved, ->() { where(is_approved: true) }
  paginates_per 10

  validates :name, presence: true

  def self.create_context(name, user_id)
    context = self.where(name: name).first
    return (context.present? ? context : self.create(name: name, user_id: user_id))
  end

end
