module ButtonsHelper
  def delete_button(text, path, is_inline = false)
    button_to text, path,
              method: :delete,
              class: "gem-c-button govuk-button govuk-button--warning",
              form_class: ("app-display-inline" if is_inline)
  end
end
