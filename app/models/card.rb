class Card < ApplicationRecord
  BONUS_IF = 100
  BONUS_RATE = 0.1

  belongs_to :user
  belongs_to :shop

  scope :filter_by_shop_id, ->(shop_id) { joins(:shop).where(shop: { id: shop_id }) }
  scope :filter_by_user_id, ->(user_id) { joins(:user).where(user: { id: user_id }) }

  def add_bonuses(amount)
    self.bonuses += (BONUS_RATE * amount).floor if amount >= BONUS_IF
  end

  def use_bonuses(amount)
    if amount.ceil <= self.bonuses
      amount_due = 0
      self.bonuses -= amount.ceil
    else
      amount_due = amount - self.bonuses
      self.bonuses = 0
    end

    amount_due
  end
end
