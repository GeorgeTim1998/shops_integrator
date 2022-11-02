class Api::V1::UsersController < ApplicationController
  deserializable_resource :user, only: %i[create update]
  before_action :find_user, only: :update

  def index
    @users = User.filter_by_shop(shop_id) if params[:shop_id].present?
    @users = User.all if params[:shop_id].blank?

    render jsonapi: @users, meta: {}
  end

  def show
    @user = User.where(id: params[:id])

    render jsonapi: @user, meta: {}
  end

  def update
    @user.update(user_params)

    if @user.save
      render jsonapi: @user, meta: {}
    else
      render json: @user, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      render jsonapi: @user, status: :created, meta: {}
    else
      render json: @user, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private

  def shop_id
    params[:shop_id].to_i
  end

  def user_params
    params.require(:user).permit(:email, :negative_balance)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
