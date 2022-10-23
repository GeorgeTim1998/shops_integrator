class User < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :shops, through: :cards
end
