module DenylistEntriesHelper
  DENYLIST_ENTRY_MATCH_TYPE_TAG_COLOURS = {
    exact_match: "blue",
    contains: "grey",
  }

  def denylist_entry_phrase_with_visible_spaces(denylist_entry)
    denylist_entry.phrase.gsub(/\s/, "⎵")
  end

  def denylist_entry_match_type_tag(denylist_entry)
    scope = "activerecord.attributes.denylist_entry.match_type_values"
    colour = DENYLIST_ENTRY_MATCH_TYPE_TAG_COLOURS[denylist_entry.match_type.to_sym]

    tag.span(
      t(denylist_entry.match_type, scope:),
      class: "govuk-tag govuk-tag--#{colour}",
      title: t(denylist_entry.match_type, scope: "hints.denylist_entry_match_type"),
    )
  end
end
