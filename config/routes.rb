Rails.application.routes.draw do
  resources :books
  resources :authors

  resources :titles, only: :index
  resources :series, only: :index

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'books#index'
end
