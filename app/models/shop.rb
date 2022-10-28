class Shop < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :users, through: :cards

  scope :filter_by_user, ->(user_id) { joins(:users).where(users: { id: user_id }) }

  validates :name, uniqueness: { scope: :name }
end
