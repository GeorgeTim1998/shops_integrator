class Shop < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :users, through: :cards

  validates :name, presence: true
  validates :name, uniqueness: { scope: :name }

  scope :filter_by_user, ->(user_id) { joins(:users).where(users: { id: user_id }) }
end
