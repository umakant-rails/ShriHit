class Writer < ApplicationRecord
  has_many :articles

  def self.create_writer(name)
    writer = self.where(name: name).first
    return (writer.present? ? writer : self.create(name: name))
  end

end
