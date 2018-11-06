Rails.application.routes.draw do
  root to: "posts#index"
  resources :posts, only: [:index, :show]
  resource :sessions, only: [:create, :destroy]
end
