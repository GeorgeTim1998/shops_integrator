class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :users, through: :cards
  has_many :cards
end
