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

cards.append(Card.create(user: users[0], shop: shops[0]))		
cards.append(Card.create(user: users[1], shop: shops[0]))		
cards.append(Card.create(user: users[2], shop: shops[0]))		

cards.append(Card.create(user: users[3], shop: shops[1]))		
cards.append(Card.create(user: users[4], shop: shops[1]))		
cards.append(Card.create(user: users[5], shop: shops[1]))		

cards.append(Card.create(user: users[6], shop: shops[2]))		
cards.append(Card.create(user: users[7], shop: shops[2]))		
cards.append(Card.create(user: users[8], shop: shops[2]))
