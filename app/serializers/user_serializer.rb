class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :shops do
    {
      links: {
        related: "/api/v1/shops?user_id=#{object.id}"
      }
    }
  end

  has_many :cards do
    {
      links: {
        related: "/api/v1/cards?user_id=#{object.id}"
      }
    }
  end
end
