module ApplicationHelper
  # Given an enumerable list of resources, returns a list of links to each resource with the text provided by the block.
  #
  # Example:
  # ```erb
  # <%= resource_link_list(resources) { it.name } %>
  # ```
  def resource_link_list(resources, &block)
    items = resources.map do |resource|
      link_to(block.call(resource), resource, class: "govuk-link")
    end
    render(
      "govuk_publishing_components/components/list",
      items:,
    )
  end
end
