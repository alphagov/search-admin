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
        text: "Boosts",
        href: boosts_path,
        active: controller.controller_name == "boosts",
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
