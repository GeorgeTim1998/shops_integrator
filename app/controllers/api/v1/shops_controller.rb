class Api::V1::ShopsController < ApplicationController
  before_action :find_shop, only: :update
  before_action :find_card, only: :buy

  def index
    @shops = Shop.filter_by_user(user_id) if params[:user_id].present?
    @shops = Shop.all if params[:user_id].blank?

    render json: @shops
  end

  def update
    @shop.update(shop_params)

    if @shop.save
      render json: @shop
    else
      render json: @shop, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      render json: @shop
    else
      render json: @shop, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def show
    @shop = Shop.where(id: params[:id])

    render json: @shop
  end

  def buy
    @card.add_bonuses(params[:amount])
    amount_due = @card.use_bonuses(params[:amount]) if params[:use_bonuses]

    render json: @card, serializer: BuySerializer, success: true, amount_due:
  end

  private

  def find_card
    @card = User.find(params[:user_id]).cards.where(shop: params[:id]).first
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
