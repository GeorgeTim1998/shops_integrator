class Api::V1::ShopsController < ApplicationController
  deserializable_resource :shop, only: :create
  before_action :find_shop, only: :update

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
    @card = User.find(params[:user_id]).cards.where(shop: params[:id]).first
    @card.add_bonuses(params[:amount])
    amount_due = @card.use_bonuses(params[:amount]) if params[:use_bonuses]

    render json: @card, serializer: BuySerializer, success: true, amount_due:
  rescue NoMethodError, ActiveRecord::RecordNotFound
    render json: error, adapter: :json, status: :unprocessable_entity
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

  def error
    {
      success: false,
      errors: {
        amount: ['is required'],
        user_id: ['is required']
      }
    }
  end
end
