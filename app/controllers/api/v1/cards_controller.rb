class Api::V1::CardsController < ApplicationController
  def index
    @cards = Card.where(nil)
    filtering_params(params).each do |key, value|
      @cards = @cards.public_send("filter_by_#{key}", value) if value.present?
    end

    render json: @cards
  end

  private

  def user_id
    params[:user_id].to_i
  end

  def shop_id
    params[:shop_id].to_i
  end

  def filters_abscent?
    params[:user_id].blank? && params[:shop_id].blank?
  end

  def filtering_params(params)
    params.slice(:user_id, :shop_id)
  end
end
