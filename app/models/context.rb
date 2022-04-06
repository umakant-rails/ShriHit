class Context < ApplicationRecord
  has_many :articles
  belongs_to :theme, optional: true

  def self.create_context(name)
    context = self.where(name: name).first
    return (context.present? ? context : self.create(name: name))
  end

end
