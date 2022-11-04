class Api::V1::ShopsController < ApplicationController
  deserializable_resource :shop, only: %i[create update]

  before_action :find_shop, only: :update
  before_action :validate_params, only: :buy
  before_action :find_card, only: :buy

  def index
    @shops = Shop.filter_by_user(user_id) if params[:user_id].present?
    @shops = Shop.all if params[:user_id].blank?

    render jsonapi: @shops, meta: {}
  end

  def show
    @shop = Shop.where(id: params[:id])

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
    @card.add_bonuses(params[:amount])
    amount_due = @card.amount_due(params[:amount], params[:use_bonuses])

    render json: buy_success(@card, amount_due)
  end

  private

  def find_card
    @card = Card.find_by(shop: params[:id].to_f, user: params[:user_id].to_i)
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
end
