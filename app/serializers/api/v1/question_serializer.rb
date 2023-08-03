class Api::V1::QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :created_at, :updated_at

  has_many :comments
  has_many :files, serializer: Api::V1::FilesSerializer
  has_many :links, serializer: Api::V1::LinksSerializer
  belongs_to :user

  def rating
    object.votes_sum
  end

end
