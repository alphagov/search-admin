Rails.application.routes.draw do
  resources :bets
  resources :queries

  root 'queries#index'
end
