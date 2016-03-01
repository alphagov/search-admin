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

  def display_value(v)
    if v.is_a?(Hash)
      table_for(v)
    elsif v.is_a?(Array)
      content_tag :ul do
        v.map { |ae| content_tag :li, display_value(ae) }.join.html_safe
      end
    elsif v.blank?
      "<em>empty</em>".html_safe
    else
      v
    end
  end
end
