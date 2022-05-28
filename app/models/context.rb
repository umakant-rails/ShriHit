class Context < ApplicationRecord
  has_many :articles
  belongs_to :theme, optional: true
  belongs_to :user, optional: true

  scope :pending_for_approval, ->() { where(is_approved: nil) }
  scope :approved, ->() { where(is_approved: true) }

  def self.create_context(name, user_id)
    context = self.where(name: name).first
    return (context.present? ? context : self.create(name: name, user_id: user_id))
  end

end
