Rails.application.routes.draw do
  resources :merchants
  namespace :api do
    namespace :v1 do
      resources :transactions, only: :create
    end
  end
end
