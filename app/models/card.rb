class Card < ApplicationRecord
  BONUS_IF = 100
  BONUS_RATE = 0.1

  belongs_to :user
  belongs_to :shop

  validates :user_id, presence: true, uniqueness: { scope: :shop_id }

  scope :filter_by_shop_id, ->(shop_id) { joins(:shop).where(shop: { id: shop_id }) }
  scope :filter_by_user_id, ->(user_id) { joins(:user).where(user: { id: user_id }) }

  def add_bonuses(amount)
    update(bonuses: self.bonuses += (BONUS_RATE * amount).floor) if amount >= BONUS_IF
  end

  def use_bonuses(amount)
    return use_bonuses_negative(amount) if user.negative_balance

    if amount.ceil <= self.bonuses
      amount_due = 0
      update(bonuses: self.bonuses -= amount.ceil)
    else
      amount_due = amount - self.bonuses
      update(bonuses: 0)
    end

    amount_due
  end

  def use_bonuses_negative(amount)
    cards = user.cards
    cards_bonuses = all_cards_bonuses(cards)

    if amount > cards_bonuses
      cards_bonuses, amount_due = sum_cards_bonuses(cards, amount)
      update(bonuses: self.bonuses - cards_bonuses)
    end

    amount_due
  end

  def amount_due(amount, use_bonuses)
    if use_bonuses
      use_bonuses(amount)
    else
      amount
    end
  end

  def all_cards_bonuses(cards)
    sum = 0
    cards.each do |card|
      sum += card.bonuses
    end

    sum
  end

  private

  def sum_cards_bonuses(cards, amount)
    cards_bonuses = 0
    amount_remaining = amount

    cards.each do |card|
      if less_then_amount?(cards_bonuses, card, amount)
        cards_bonuses += card.bonuses
        amount_remaining -= card.bonuses
        card.update(bonuses: 0)
      else
        cards_bonuses += amount_remaining
        card.update(bonuses: card.bonuses - amount_remaining)
      end
    end

    [cards_bonuses, amount - all_cards_bonuses(cards)]
  end

  def less_then_amount?(cards_bonuses, card, amount)
    cards_bonuses + card.bonuses < amount
  end
end
