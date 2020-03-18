Rails.application.routes.draw do
  resources :bets, except: %i[index show] do
    member do
      post :deactivate
    end
  end
  resources :queries
  resources :recommended_links, path: "/recommended-links"
  resources :results, only: %i[index show destroy]
  resources(
    :similar_search_results,
    only: %i[new show],
    path: "similar-search-results",
  )

  root "queries#index"

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
