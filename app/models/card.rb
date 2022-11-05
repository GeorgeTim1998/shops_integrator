class Card < ApplicationRecord
  BONUS_IF = 100
  BONUS_RATE = 0.01

  belongs_to :user
  belongs_to :shop

  validates :user_id, presence: true, uniqueness: { scope: :shop_id }

  scope :filter_by_shop_id, ->(shop_id) { joins(:shop).where(shop: { id: shop_id }) }
  scope :filter_by_user_id, ->(user_id) { joins(:user).where(user: { id: user_id }) }

  def add_bonuses(amount)
    update(bonuses: bonuses + (BONUS_RATE * amount).floor) if amount >= BONUS_IF
  end

  def use_bonuses(amount)
    amount_due = amount
    return use_bonuses_negative(amount) if user.negative_balance && bonuses.zero?

    unless bonuses.negative?
      if amount.ceil <= bonuses
        amount_due = 0
        update(bonuses: bonuses - amount.ceil)
      else
        amount_due = amount - bonuses
        update(bonuses: 0)
      end
    end

    amount_due
  end

  def use_bonuses_negative(amount)
    amount_due = amount
    cards = user.cards
    cards_bonuses = all_cards_bonuses(cards)

    if amount.ceil <= cards_bonuses
      cards_bonuses, amount_due = sum_cards_bonuses(cards, amount)
      update(bonuses: bonuses - cards_bonuses)
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
    amount_remaining = amount.ceil

    cards.each do |card|
      if less_then_amount?(cards_bonuses, card, amount_remaining)
        cards_bonuses += card.bonuses
        amount_remaining -= card.bonuses
        card.update(bonuses: 0)
      else
        cards_bonuses += amount_remaining
        card.update(bonuses: card.bonuses - amount_remaining)
      end
    end

    [cards_bonuses, 0]
  end

  def less_then_amount?(cards_bonuses, card, amount_remaining)
    cards_bonuses + card.bonuses <= amount_remaining
  end
end
