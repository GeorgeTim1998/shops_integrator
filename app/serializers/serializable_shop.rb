class SerializableShop < JSONAPI::Serializable::Resource
  type 'shops'
  attributes :name

  has_many :users do
    link :related do
      "/api/v1/cards?filter[shop_id]=#{@object.id}"
    end
  end

  has_many :cards do
    link :related do
      "/api/v1/cards?filter[shop_id]=#{@object.id}"
    end
  end
end
