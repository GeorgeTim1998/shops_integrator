class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'
  attributes :email, :negative_balance

  has_many :shops do
    link :related do
      "/api/v1/cards?filter[user_id]=#{@object.id}"
    end
  end

  has_many :cards do
    link :related do
      "/api/v1/cards?filter[user_id]=#{@object.id}"
    end
  end
end
