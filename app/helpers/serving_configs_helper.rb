module ServingConfigsHelper
  def serving_config_default_tag(serving_config)
    scope = "activerecord.attributes.serving_config.default_status_values"

    if serving_config.default?
      tag.span(t("default", scope:), class: "govuk-tag govuk-tag--blue")
    else
      tag.span(t("non_default", scope:), class: "govuk-tag govuk-tag--grey")
    end
  end
end
