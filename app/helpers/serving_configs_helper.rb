module ServingConfigsHelper
  SERVING_CONFIG_USE_CASE_TAG_COLOURS = {
    live: "green",
    preview: "yellow",
    system: "grey",
  }.freeze

  def serving_config_use_case_tag(serving_config)
    scope = "activerecord.attributes.serving_config.use_case_values"
    colour = SERVING_CONFIG_USE_CASE_TAG_COLOURS[serving_config.use_case.to_sym]

    tag.span(
      t(serving_config.use_case, scope:),
      class: "govuk-tag govuk-tag--#{colour}",
    )
  end

  # Returns the controls attached to the given serving config grouped by action in rows for a
  # summary card component.
  def serving_config_attached_controls_rows(serving_config)
    serving_config.controls.group_by(&:action_name).map do |action_name, controls|
      {
        key: t(action_name, scope: "activerecord.attributes.control.action_names").pluralize,
        value: resource_link_list(controls) { it.display_name },
      }
    end
  end
end
