# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::ActiveRecord,
  )
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resources :boosts
  resources :recommended_links, path: "/recommended-links"

  root "recommended_links#index"
end
