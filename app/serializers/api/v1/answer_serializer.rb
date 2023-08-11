class Api::V1::AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :comments
  has_many :files, serializer: Api::V1::FilesSerializer
  has_many :links, serializer: Api::V1::LinksSerializer
  belongs_to :user
end
