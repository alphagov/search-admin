# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::ActiveRecord,
  )

  resources :recommended_links, path: "/recommended-links"
  resources :controls

  root "recommended_links#index"

  mount GovukAdminTemplate::Engine, at: "/style-guide"
end
