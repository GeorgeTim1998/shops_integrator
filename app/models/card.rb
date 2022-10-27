class Card < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  scope :filter_by_shop_id, ->(shop_id) { joins(:shop).where(shop: { id: shop_id }) }
  scope :filter_by_user_id, ->(user_id) { joins(:user).where(user: { id: user_id }) }
end
