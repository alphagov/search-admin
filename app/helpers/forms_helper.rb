module FormsHelper
  def render_govuk_input(form, field_name)
    render(
      "govuk_publishing_components/components/input",
      basic_field_properties(form, field_name),
    )
  end

  def render_govuk_textarea(form, field_name)
    render(
      "govuk_publishing_components/components/textarea",
      basic_field_properties(form, field_name),
    )
  end

private

  def basic_field_properties(form, field_name)
    {
      label: {
        text: form.object.class.human_attribute_name(field_name),
      },
      name: "#{form.object_name}[#{field_name}]",
      value: form.object[field_name],
      error_items: error_items(form, field_name),
    }
  end

  def error_items(form, field_name)
    return nil if form.object.errors[field_name].empty?

    form.object.errors[field_name].map { |message| { text: message } }
  end
end
