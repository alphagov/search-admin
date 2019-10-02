module ButtonsHelper
  def delete_button(text, path)
    button_to text, path,
              method: :delete,
              class: "btn btn-danger",
              data: { confirm: "Are you sure?" }
  end
end
