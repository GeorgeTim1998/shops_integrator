Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :cards, only: %i[index show]
      resources :users, only: %i[show update index create]

      resources :shops, only: %i[show update index create] do
        member do
          post :buy
        end
      end
    end
  end
end
