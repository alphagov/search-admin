module ApplicationHelper
  def navigation_items
    return [] unless current_user

    [
      {
        text: t("recommended_links.index.page_title"),
        href: recommended_links_path,
        active: controller.controller_name == "recommended_links",
      },
      {
        text: current_user.name,
        href: Plek.new.external_url_for("signon"),
      },
      {
        text: t("common.menu.sign_out"),
        href: "/auth/gds/sign_out",
      },
    ]
  end
end
