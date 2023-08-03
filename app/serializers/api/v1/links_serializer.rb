class Api::V1::LinksSerializer < ActiveModel::Serializer
  attributes :name, :url
end
