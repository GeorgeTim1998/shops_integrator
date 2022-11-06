class Api::V1::ShopsController < ApplicationController
  deserializable_resource :shop, only: %i[create update]

  before_action :find_shop, only: :update
  before_action :validate_params, only: :buy
  before_action :find_card, only: :buy

  def index
    @shops = Shop.all
    filtering_params.each do |_key, hash|
      hash.each do |key, value|
        @shops = @shops.public_send("filter_by_#{key}", value) if value.present?
      end
    end

    render jsonapi: @shops.to_a, meta: {}
  end

  def show
    @shop = Shop.find(params[:id])

    render jsonapi: @shop, meta: {}
  end

  def update
    @shop.update(shop_params)

    if @shop.save
      render jsonapi: @shop, meta: {}
    else
      render json: error_renderer(@shop.errors), status: :unprocessable_entity
    end
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      render jsonapi: @shop, status: :created, meta: {}
    else
      render json: error_renderer(@shop.errors), status: :unprocessable_entity
    end
  end

  def buy
    amount_due = @card.amount_due(params[:amount], params[:use_bonuses])
    @card.add_bonuses(params[:amount]) unless params[:use_bonuses]

    render json: buy_success(@card, amount_due)
  end

  private

  def find_card
    @card = Card.find_by(shop: params[:id].to_i, user: params[:user_id].to_i)
    create_card if @card.nil?
  end

  def create_card
    shop = Shop.find(params[:id].to_i)
    user = User.find(params[:user_id].to_i)
    @card = Card.new(shop:, user:)
    @card.save
    @card
  end

  def user_id
    params[:user_id].to_i
  end

  def find_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name)
  end

  def filtering_params
    params.slice(:filter)
  end
end
