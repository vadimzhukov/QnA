class Api::V1::QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at
end
