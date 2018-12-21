Rails.application.routes.draw do

  root to: "home#show"

  # TODO: adminsはnamespace: admin配下に持っていきたい。今はページがなくてやりづらいのであとで変更する。

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords'
  }

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  namespace :admin do
    get 'home', to: 'home#show'
  end

  # TODO: これは仮に作ったのであとでコントローラごと消す
  get 'home', to: 'home#show'


end
