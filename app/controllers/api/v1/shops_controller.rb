class Api::V1::ShopsController < ApplicationController
  deserializable_resource :shop, only: %i[create update]
  before_action :find_shop, only: :update

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
    @card = User.find(params[:user_id]).cards.where(shop: params[:id]).first
    @card.add_bonuses(params[:amount])
    amount_due = @card.amount_due(params[:amount], params[:use_bonuses])

    render json: buy_success(@card, amount_due)
  rescue NoMethodError, ActiveRecord::RecordNotFound, ActionDispatch::Http::Parameters::ParseError
    render json: buy_error, adapter: :json, status: :unprocessable_entity
  end

  private

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
