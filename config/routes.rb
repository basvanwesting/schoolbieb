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

  namespace :book_use_case, as: :book_use_case do
    resources :enables,  only: [:new, :create]
    resources :disables, only: [:new, :create]
  end

  namespace :lending do
    resources :borrows, only: [:new, :create]
    resources :returns, only: [:new, :create]
  end

  resources :authors
  resources :lenders
  resources :loans
  resources :stickers, only: :index

  namespace :admin do
    resources :users
  end
  devise_for :users
  resource :current_user, only: [:show, :edit, :update]

  root to: 'books#index'
  get '/test_exception_notifier', controller: 'authors', action: 'test_exception_notifier'
end
