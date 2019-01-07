module TableHelper
  def table_for(hash)
    content_tag :table, class: 'table key-value-table' do
      rows = hash.map do |k, v|
        content_tag :tr do
          content_tag(:td, k) + content_tag(:td, display_value(v))
        end
      end

      rows.join.html_safe
    end
  end

  def display_value(value)
    if value.is_a?(Hash)
      table_for(value)
    elsif value.is_a?(Array)
      content_tag :ul do
        value.map { |ae| content_tag :li, display_value(ae) }.join.html_safe
      end
    elsif value.blank?
      "<em>empty</em>".html_safe
    else
      value
    end
  end
end
