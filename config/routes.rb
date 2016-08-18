Rails.application.routes.draw do
  resources :bets, except: [:index, :show]
  resources :queries
  resources :recommended_links, path: "/recommended-links"
  resources :results, only: [:index, :show, :destroy]

  root 'queries#index'

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
