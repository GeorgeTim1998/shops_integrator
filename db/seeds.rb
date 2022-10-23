require 'faker'

Shop.destroy_all

shops = []
3.times do
  shops.append(Shop.create(name: Faker::Company.unique.name))
end
