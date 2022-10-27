class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :users do
    {
      links: {
        related: "/api/v1/users?shop_id=#{object.id}"
      }
    }
  end

  has_many :cards do
    {
      links: {
        related: "/api/v1/cards?shop_id=#{object.id}"
      }
    }
  end
end
