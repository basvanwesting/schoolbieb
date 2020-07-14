Rails.application.routes.draw do
  resources :books, only: [:index] do
    collection do
      get :stickers
    end
    member do
      get :qr
    end
  end
  namespace :books, as: :book do
    resources :fictions
    resources :non_fictions
  end

  namespace :book_use_case do
    resources :borrows,  only: [:new, :create]
    resources :returns,  only: [:new, :create]
    resources :enables,  only: [:new, :create]
    resources :disables, only: [:new, :create]
  end

  resources :authors
  resources :lenders
  resources :loans

  namespace :admin do
    resources :users
  end
  devise_for :users
  resource :current_user, only: [:show, :edit, :update]

  root to: 'books#index'
  get '/test_exception_notifier', controller: 'authors', action: 'test_exception_notifier'
end
