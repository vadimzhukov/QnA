class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :comments
  has_many :comments
  belongs_to :user
end
