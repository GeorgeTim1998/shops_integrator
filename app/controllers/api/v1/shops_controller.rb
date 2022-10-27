class Api::V1::ShopsController < ApplicationController
  def index
    @shops = Shop.filter_by_user(user_id) if params[:user_id].present?
    @shops = Shop.all if params[:user_id].blank?

    render json: @shops
  end

  private

  def user_id
    params[:user_id].to_i
  end
end
