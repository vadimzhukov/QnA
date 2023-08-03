class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :comments, :answers
  has_many :comments
  has_many :answers
  belongs_to :user

end
