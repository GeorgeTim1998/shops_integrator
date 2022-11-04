class SerializableCard < JSONAPI::Serializable::Resource
  type 'cards'
  attributes :bonuses
  belongs_to :shop do
    link :related do
      "/api/v1/shops/#{@object.shop_id}"
    end
  end

  belongs_to :user do
    link :related do
      "/api/v1/users/#{@object.user_id}"
    end
  end
end
