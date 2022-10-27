class CardSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :shop do
    {
      links: {
        related: "/api/v1/shops/#{object.shop_id}"
      }
    }
  end

  belongs_to :user do
    {
      links: {
        related: "/api/v1/users/#{object.user_id}"
      }
    }
  end
end
