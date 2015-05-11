module IconHelper
  # http://getbootstrap.com/components/#glyphicons-glyphs
  def icon(icon_name)
    content_tag :i, '', class: "glyphicon glyphicon-#{icon_name}"
  end
end
