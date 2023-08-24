class Comment < ApplicationRecord
  belongs_to :commentable, touch: true
  belongs_to :user

  validates :commentable, :user_id, :body, presence: true
end
