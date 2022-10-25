class CardSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :shop
  belongs_to :user
end
