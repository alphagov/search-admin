Rails.application.routes.draw do
  resources :bets, except: [:index, :show]
  resources :queries

  root 'queries#index'
end
