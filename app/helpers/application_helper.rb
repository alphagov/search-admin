module ApplicationHelper
  def navigation_items
    return [] unless current_user

    [
      {
        text: "Queries",
        href: queries_path,
        active: is_current?(queries_path),
      },
      {
        text: "External links",
        href: recommended_links_path,
        active: is_current?(recommended_links_path),
      },
      {
        text: "Search results",
        href: results_path,
        active: is_current?(results_path),
      },
      {
        text: "Similar search results",
        href: new_similar_search_result_path,
        active: is_current?(new_similar_search_result_path),
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

  def is_current?(link)
    recognized = Rails.application.routes.recognize_path(link)
    recognized[:controller] == params[:controller] &&
      recognized[:action] == params[:action]
  end
end
