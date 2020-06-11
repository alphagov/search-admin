module IconHelper
  # http://getbootstrap.com/components/#glyphicons-glyphs
  def icon(icon_name)
    tag.i "", class: "glyphicon glyphicon-#{icon_name}"
  end
end
