module PresentationHelper
  def subdivison_link(subdivision)
    case subdivision.title
    when "Кафедра математики"
      subdivision.abbr = "математики"
    when "Экономический факультет"
      subdivision.abbr = "ЭФ"
    when "Кафедра физики"
      subdivision.abbr = "физики"
    when "Управление информатизации"
      subdivision.abbr = "УИ"
    end

    if subdivision.abbr.present?
      if subdivision.url
        link_to(subdivision.abbr, subdivision.url, title: subdivision.title)
      else
        content_tag :abbr, subdivision.abbr, title: subdivision.title
      end
    end
  end
end
