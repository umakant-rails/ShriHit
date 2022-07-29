class CommentReporting < ApplicationRecord
  belongs_to :user
  belongs_to :article
  belongs_to :comment
end
