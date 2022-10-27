class Api::V1::UsersController < ApplicationController
  def index
    @users = User.filter_by_shop(shop_id) if params[:shop_id].present?
    @users = User.all if params[:shop_id].blank?

    render json: @users
  end

  private

  def shop_id
    params[:shop_id].to_i
  end
end
