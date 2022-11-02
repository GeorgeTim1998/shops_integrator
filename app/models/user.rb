class User < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :shops, through: :cards

  validates :email, presence: true
  validates :email, uniqueness: { scope: :email }

  scope :filter_by_shop, ->(shop_id) { joins(:shops).where(shops: { id: shop_id }) }
end
