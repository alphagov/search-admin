# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::ActiveRecord,
  )
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resources :controls, except: %i[new]
  scope :controls, only: %i[new], as: "control" do
    # NOTE: Rails does not accept :controller as an argument on `scope`, so we need to duplicate
    # it in every resource definition in this scope.
    resources :with_boost_actions, controller: :controls, action_type: Control::BoostAction
    resources :with_filter_actions, controller: :controls, action_type: Control::FilterAction
  end
  resources :completion_denylist_entries, except: %i[show]
  resources :completion_denylist_entry_imports, only: %i[new create]

  resources :recommended_links, path: "/recommended-links"

  root "recommended_links#index"
end
