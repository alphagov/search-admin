module CompletionDenylistEntriesHelper
  # see https://design-system.service.gov.uk/components/tag#additional-colours
  COMPLETION_DENYLIST_ENTRY_MATCH_TYPE_TAG_COLOURS = {
    exact_match: "blue",
    contains: "grey",
  }.freeze

  def completion_denylist_entry_phrase_with_visible_spaces(completion_denylist_entry)
    space = tag.span(" ", class: "app-denylist-entry-visible-space")
    completion_denylist_entry.phrase.gsub(/\s/, space).html_safe
  end

  def completion_denylist_entry_match_type_tag(completion_denylist_entry)
    scope = "activerecord.attributes.completion_denylist_entry.match_type_values"
    colour = COMPLETION_DENYLIST_ENTRY_MATCH_TYPE_TAG_COLOURS[
      completion_denylist_entry.match_type.to_sym,
    ]

    tag.span(
      t(completion_denylist_entry.match_type, scope:),
      class: "govuk-tag govuk-tag--#{colour}",
      title: t(completion_denylist_entry.match_type, scope: "hints.completion_denylist_entry_match_type"),
    )
  end
end
