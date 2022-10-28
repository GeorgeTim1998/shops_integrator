class Api::V1::ShopsController < ApplicationController
  before_action :find_shop, only: :update

  def index
    @shops = Shop.filter_by_user(user_id) if params[:user_id].present?
    @shops = Shop.all if params[:user_id].blank?

    render json: @shops
  end

  def update
    @shop.update(shop_params)
    render json: @shop
  end

  def create
    @shop = Shop.new(shop_params)
    @shop.save
    render json: @shop
    # rescue ActiveRecord::RecordNotUnique => e
    #   render json: ErrorSerializer.new(e), status: :unprocessable_entity
  end

  def show
    @shop = Shop.where(id: params[:id])

    render json: @shop
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
