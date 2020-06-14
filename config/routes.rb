Rails.application.routes.draw do
  resources :books, only: [:index] do
    member do
      get :qr
      post :unset_sticker_pending
      post :set_sticker_pending
    end
  end
  namespace :books, as: :book do
    resources :fictions
    resources :non_fictions
  end

  namespace :lending do
    resources :borrows, only: [:new, :create]
    resources :returns, only: [:new, :create]
  end

  resources :authors
  resources :lenders
  resources :loans

  resources :titles,   only: :index
  resources :series,   only: :index
  resources :stickers, only: :index

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'books#index'
  get '/test_exception_notifier', controller: 'authors', action: 'test_exception_notifier'
end
