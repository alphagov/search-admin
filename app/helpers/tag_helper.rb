module TagHelper
  # Set the page <title> and return the <h1> tag.
  def page_title(string)
    content_for :page_title, "#{string} - Search Admin"
    content_tag :h1, string, class: "page-title-with-border"
  end
end
