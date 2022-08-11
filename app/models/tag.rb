class Tag < ApplicationRecord
  belongs_to :user
  paginates_per 10

  scope :pending, ->() { where(is_approved: false) }
  scope :approved, ->() { where(is_approved: true) }
  
end
