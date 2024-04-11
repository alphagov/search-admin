# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::ActiveRecord,
  )

  resources :bets, except: %i[index show] do
    member do
      post :deactivate
    end
  end
  resources :queries
  resources :recommended_links, path: "/recommended-links"

  root "queries#index"

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
