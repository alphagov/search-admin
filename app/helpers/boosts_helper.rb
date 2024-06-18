module BoostsHelper
  def boost_status_tag(boost)
    if boost.active?
      content_tag(:span, "Active", class: "govuk-tag govuk-tag--blue")
    else
      content_tag(:span, "Not active", class: "govuk-tag govuk-tag--grey")
    end
  end
end
