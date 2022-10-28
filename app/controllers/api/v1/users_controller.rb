class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: :update
  def index
    @users = User.filter_by_shop(shop_id) if params[:shop_id].present?
    @users = User.all if params[:shop_id].blank?

    render json: @users
  end

  def show
    @user = User.where(id: params[:id])

    render json: @user
  end

  def update
    @user.update(user_params)
    render json: @user
  end

  def create
    @user = User.new(user_params)
    @user.save
    render json: @user
    # rescue ActiveRecord::RecordNotUnique => e
    #   render json: ErrorSerializer.new(e), status: :unprocessable_entity
  end

  private

  def shop_id
    params[:shop_id].to_i
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
