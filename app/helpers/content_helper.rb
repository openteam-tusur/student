module ContentHelper

  def replace_content_for_employment(from_html, to_html)
    doc = Nokogiri::HTML::DocumentFragment.parse(from_html)
    form = doc.at_css('div.apply-form')
    return from_html unless form.present?
    form.replace to_html

    doc.to_html.html_safe
  end

  def chief_hash(directory_info, subdivision_title)
    directory_info.select{ |subdivision| subdivision.title == subdivision_title }.first.try(:chief)
  end

end
