module ApplicationHelper
  def navigation_items
    return [] unless current_user

    [
      {
        text: "External links",
        href: recommended_links_path,
        active: controller.controller_name == "recommended_links",
      },
      {
        text: DiscoveryEngineControl.model_name.human.pluralize,
        href: discovery_engine_controls_path,
        active: controller.controller_name == "discovery_engine_controls",
      },
      {
        text: current_user.name,
        href: Plek.new.external_url_for("signon"),
      },
      {
        text: "Sign out",
        href: "/auth/gds/sign_out",
      },
    ]
  end
end
