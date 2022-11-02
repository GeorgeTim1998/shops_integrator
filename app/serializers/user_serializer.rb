class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :negative_balance
  has_many :shops do
    {
      links: {
        related: "/api/v1/shops?filter[user_id]=#{object.id}"
      }
    }
  end

  has_many :cards do
    {
      links: {
        related: "/api/v1/cards?filter[user_id]=#{object.id}"
      }
    }
  end
end
