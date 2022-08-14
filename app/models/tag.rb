class Tag < ApplicationRecord

  has_many :article_tags
  has_many :articles, through: :article_tags
  belongs_to :user

  paginates_per 10

  scope :pending, ->() { where(is_approved: false) }
  scope :approved, ->() { where(is_approved: true) }
  
  def self.create_tags(current_user, param_tags)
    tags = Tag.where(name: param_tags)
    new_tags = (param_tags-tags.pluck(:name))

    if new_tags.present?
      new_tags.each do |name|
        current_user.tags.create(name: name)
      end
      tags = Tag.where(name: param_tags)
      return tags
    else
      return tags
    end
  end

end
