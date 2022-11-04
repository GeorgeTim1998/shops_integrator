class Api::V1::CardsController < ApplicationController
  def index
    @cards = Card.all
    filtering_params.each do |key, value|
      @cards = @cards.public_send("filter_by_#{key}", value) if value.present?
    end

    @cards = @cards.to_a

    filtering_params_bonuses.each do |_key, value|
      if value == 'sum' && @cards.present?
        render jsonapi: @cards, meta: { stats: { bonuses: { sum: @cards.first.all_cards_bonuses(@cards) } } } and return
      end
    end

    render jsonapi: @cards, meta: {}
  end

  def show
    @card = Card.where(id: params[:id])

    render jsonapi: @card, meta: {}
  end

  private

  def filtering_params
    params.slice(:user_id, :shop_id)
  end

  def filtering_params_bonuses
    params.slice(:bonuses)
  end
end
