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
end
