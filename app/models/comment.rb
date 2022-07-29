class Comment < ApplicationRecord
  has_many :comments, as: :commentable, :dependent => :destroy
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comment_reportings
end
