module ApplicationHelper
  # Given a user, returns a mailto link to their email address.
  def user_email_link(user)
    display_name = "#{user.name} <#{user.email}>"
    mail_to(user.email, display_name, class: "govuk-link")
  end

  # For a given link, returns a GOV.UK URL if it is relative, or the value itself if it is already
  # absolute.
  def absolute_govuk_url(absolute_or_relative_link)
    return absolute_or_relative_link if absolute_or_relative_link.starts_with?("http")

    "#{Plek.new.website_root}#{absolute_or_relative_link}"
  end

  # Renders a GOV.UK formatted timestamp.
  def govuk_timestamp(datetime)
    content_tag(:time) do
      datetime.strftime("%-d %B %Y, %H:%M")
    end
  end
end
