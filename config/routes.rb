Rails.application.routes.draw do
  resources :bets, except: [:index, :show]
  resources :queries
  resources :recommended_links, path: "/recommended-links"
  resources :results, only: [:index, :show, :destroy]
  resources :similar_search_results, only: [:new, :show]

  root 'queries#index'

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
