class Api::V1::UsersController < ApplicationController
  deserializable_resource :user, only: %i[create update]
  before_action :find_user, only: :update

  def index
    @users = User.all
    filtering_params.each do |_key, hash|
      hash.each do |key, value|
        @users = @users.public_send("filter_by_#{key}", value) if value.present?
      end
    end

    render jsonapi: @users.to_a, meta: {}
  end

  def show
    @user = User.find(params[:id])

    render jsonapi: @user, meta: {}
  end

  def update
    @user.update(user_params)

    if @user.save
      render jsonapi: @user, meta: {}
    else
      render json: error_renderer(@user.errors), status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render jsonapi: @user, status: :created, meta: {}
    else

      render json: error_renderer(@user.errors), status: :unprocessable_entity
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

  def filtering_params
    params.slice(:filter)
  end
end
