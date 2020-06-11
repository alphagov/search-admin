module TableHelper
  def table_for(hash)
    tag.table class: "table key-value-table" do
      rows = hash.map do |k, v|
        tag.tr do
          tag.td(k) + tag.td(display_value(v))
        end
      end

      rows.join.html_safe
    end
  end

  def display_value(value)
    if value.is_a?(Hash)
      table_for(value)
    elsif value.is_a?(Array)
      tag.ul do
        value.map { |ae| tag.li display_value(ae) }.join.html_safe
      end
    elsif value.blank?
      "<em>empty</em>".html_safe
    else
      value
    end
  end
end
