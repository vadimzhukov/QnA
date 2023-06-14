class Comment < ApplicationRecord
  belongs_to :commentable
  belongs_to :user

  validates :commentable, :user_id, :body, presence: true
end
