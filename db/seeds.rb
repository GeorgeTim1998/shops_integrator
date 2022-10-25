require 'faker'

Card.destroy_all
Shop.destroy_all
User.destroy_all

shops = []
users = []
cards = []

3.times do
  shops.append(Shop.create(name: Faker::Company.unique.name))
end

9.times do
  users.append(User.create(email: Faker::Internet.unique.email))
end

for i in (0..users.length - 1) do
  cards.append(Card.create(user: users[i], shop: shops[i / 3]))
end
