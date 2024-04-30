module ApplicationHelper
  def navigation_items
    return [] unless current_user

    [
      {
        text: "External links",
        href: recommended_links_path,
        active: is_current?(recommended_links_path),
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

  def footer_items
    return [] unless ENV.key?("SENTRY_RELEASE")

    [
      {
        href: "https://github.com/alphagov/search-admin/releases/tag/v#{ENV['SENTRY_RELEASE']}",
        text: "Release v#{ENV['SENTRY_RELEASE']}",
      },
    ]
  end
end
