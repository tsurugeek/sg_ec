Rails.application.routes.draw do

  root to: 'user/products#index'

  # TODO: adminsはnamespace: admin配下に持っていきたい。今はページがなくてやりづらいのであとで変更する。

  devise_for :admins, module: :admins_devises, controllers: {
    sessions:      'admins_devise/sessions',
    passwords:     'admins_devise/passwords'
  }

  devise_for :users, controllers: {
    confirmations: 'users_devise/confirmations',
    sessions:      'users_devise/sessions',
    passwords:     'users_devise/passwords',
    registrations: 'users_devise/registrations'
  }

  namespace :admin do
    root 'home#show'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :products do
      collection do
        put 'update_sort_nos'
      end
    end
  end

  scope module: :user do
    get '/', to: 'products#index', as: :user_root
    resources :products, only: [:index] do
      resource :cart_product, only: [:new, :create, :destroy] do
        put :update_num
      end
    end
    resource :cart, only: [:edit, :update, :show] do
      put 'fix_products'
      get 'edit_shipping_address'
      put 'fix_shipping_address'
      put 'purchase'
      get 'show_complete'
    end
    resources :purchase_histories, only: [:index, :show]
  end


end
