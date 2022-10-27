class Shop < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :users, through: :cards

  scope :filter_by_card, ->(user_id) { joins(:users).where(users: { id: user_id }) }
end
