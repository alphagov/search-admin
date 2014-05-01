Rails.application.routes.draw do
  resources :best_bets, path: 'best-bets'

  root 'best_bets#index'
end
