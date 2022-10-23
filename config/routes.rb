Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :cards, only: %i[index show]
      resources :shops, only: %i[show update index create] # add buy action
      resources :users, only: %i[show update index create]
    end
  end
end
