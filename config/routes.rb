# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::ActiveRecord,
  )
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resources :completion_denylist_entries, except: %i[show]
  resources :completion_denylist_entry_imports, only: %i[new create]

  resources :recommended_links, path: "/recommended-links"

  root "recommended_links#index"
end
