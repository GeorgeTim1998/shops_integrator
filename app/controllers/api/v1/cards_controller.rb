class Api::V1::CardsController < ApplicationController
  def index
    @cards = Card.where(nil)
    filtering_params(params).each do |key, value|
      @cards = @cards.public_send("filter_by_#{key}", value) if value.present?
    end

    render json: @cards
  end

  private

  def filtering_params(params)
    params.slice(:user_id, :shop_id)
  end
end
