Rails.application.routes.draw do
  resources :bets, except: [:index, :show]
  resources :queries

  root 'queries#index'

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
