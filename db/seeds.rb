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

(0..users.length - 1).each do |item|
  cards.append(Card.create(user: users[item], shop: shops[item / 3]))
end
