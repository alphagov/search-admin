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
        text: "Controls",
        href: controls_path,
        active: controller.controller_name == "controls",
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
