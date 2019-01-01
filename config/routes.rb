Rails.application.routes.draw do

  root to: "user/home#show"

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
    # scopeではrootを設定できない。namespaceだけっぽい。
    # TODO: これは仮に作ったのであとでコントローラごと消す
    get '/', to: 'home#show', as: :user_root
  end


end
