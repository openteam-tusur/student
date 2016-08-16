module ApplicationHelper

  def canonical_url
    "<link rel='canonical' href='/' />" if request.path == '/ru'
  end

  def render_partial_for_region(region, prefix = nil)
    prefix = "#{prefix}_" if prefix.present?
    if region && (region.response_status == 200 || !region.response_status?)
      partial = "regions/#{prefix}#{region.template}"
      render :partial => partial,
      :locals => { :object => region.content, :extend_object => region.extend_content, :response_status => region.response_status }
    else
      partial = region.response_status? ? "regions/error_#{region.response_status}" : 'regions/error'
      render :partial => partial, :locals => { :region => region }
    end
  end

  def render_cms_navigation(hash, list_class = nil, item_class = nil, additional_class = nil)
    return '' if hash.nil? || hash.empty?

    content_tag :ul, :class => [list_class, additional_class].compact.any? ? [list_class, additional_class].compact : nil do
      hash.map do |key, value|
        klass = []
        klass << item_class
        klass << 'active' if value['selected']
        klass << 'disable-active' if hash.size == 1
        klass << 'has_children' if value['children']
        klass = klass.delete_if(&:blank?).join(' ').squish
        klass = nil if klass.empty?
        content_tag :li, :class => klass do
          render_link_for_navigation(key, value) + render_cms_navigation(value['children'], list_class, nil, value['selected'] ? 'opened' : 'closed')
        end
      end.join.html_safe
    end
  end

  def render_link_for_navigation(klass, item, data = {})
    if item['external_link'].present?
      if item['external_link'].match(/\Ahttps?/)
        link_to item['title'], item['external_link'], :class => klass, :target => :_blank, :data => data
      else
        link_to item['title'], item['external_link'], :class => klass, :data => data
      end
    else
      link_to item['title'], item['path'], :class => klass, :data => data
    end
  end

  def right_video_link(text)
    title = text.match(/<h1>(.*)<\/h1>/)[1]
    image_link = text.match(/src=["|'](.*?)["|']/)[1]
    video_link = text.match(/data-video=["|'](.*?)["|']/)[1]
    link_to title, image_link, 'data-video' => video_link, :class => 'js-colorbox-video'
  end

  def right_video_link_thumbnail(text, resolution)
    alt = text.match(/<h1>(.*)<\/h1>/)[1]
    image_link = text.match(/src=["|'](.*?)["|']/)[1]
    width, height = image_link.match(/\/(\d+-\d+)\//)[1].split('-')
    case resolution
    when 'lg'
      new_width = 230
    when 'md'
      new_width = 180
    when 'sm'
      new_width = 187
    else
      return
    end
    new_height = new_width * height.to_i / width.to_i
    video_link = text.match(/data-video=["|'](.*?)["|']/)[1]
    link_to image_link, 'data-video' => video_link, :class => 'js-colorbox-video' do
      content_tag(:span, '', :class => 'play', :style => "height: #{new_height}px;") +
      image_tag(image_link.gsub(/\/(\d+-\d+)\//, "/#{new_width}-#{new_height}/"), :size => "#{new_width}x#{new_height}", :alt => alt)
    end
  end

  def right_side_present?
    @right_navigation_with_title.present? || @right_navigation_without_title.present? || @right_links.present? || @right_advert.present? || @right_documents.present? || @right_contacts.present?
  end

  def entry_date
    @entry_date ||= begin
                      @page.regions.to_hash.each do |region_name, region|
                        if (since = region.try(:[], 'content').try(:[], 'since'))
                          return since
                        end
                      end
                      nil
                    rescue
                      nil
                    end
  end

  def from_russian_to_param(string)
    Russian.translit(string.split('.').first).downcase.gsub(' ', '-').gsub('"','').underscore if string != ""
  end

  def interval_for_event(event)
    ar = event.event_entry_properties.flat_map do |property|
      [property.since, property.until].map{|str| Date.parse(str) }
    end

    Hashie::Mash.new({since: ar.min, until: ar.max})
  end

  def event_interval_markup(event)
    interval = interval_for_event(event)
    interval.since.month == interval.until.month ? one_month(interval) : two_months(interval)
  end

  def one_month(interval)
    result = ''

    result << content_tag(:span, [interval.since, interval.until].map{|d| I18n.l(d, format: '%d')}.join('&ndash;').html_safe, class: 'dates-range' ) unless interval.since == interval.until
    result << content_tag(:span, [interval.since].map{|d| I18n.l(d, format: '%d')}.join('&ndash;').html_safe, class: 'dates-range' ) if interval.since == interval.until
    result << ' '
    result << content_tag(:span, I18n.l(interval.since, format: '%b'), class: 'one-month')
    result << ' '
    result << content_tag(:span, I18n.l(interval.since, format: '%Y'), class: 'year')

    result.html_safe
  end

  def two_months(interval)
    result = []
    [interval.since, interval.until].each do |d|
      result << [ content_tag(:span, I18n.l(d, format: '%d'), class: 'dates-range'),
                  content_tag(:span, I18n.l(d, format: '%b'), class: 'short-month') ].join(' ')
    end

    result = result.join(" <span class='dash'>&ndash;</span> ")
    result << ' '
    result << content_tag(:span, l(interval.since, format: '%Y'), class: 'year')

    result.html_safe
  end

  def event_locations(event)
    event.event_entry_properties.map{ |property| property.location }.join(", ")
  end

  def abbriviate_subdivision_title(title)
    abbr = title.split('(').last.sub(')', '').squish
    return 'ef' if title == 'Экономический факультет'

    Russian::transliterate(abbr).gsub(/[^[:alnum:]]+/, '-').downcase.gsub(/\A-+/, '').gsub(/-+\z/, '')
  end

  def normalize_subdivision_title(title)
    title.split('(').first.squish.mb_chars.downcase.gsub(/[[:space:]]/, ' ')
  end

  def fetch_subdivisions_titles(subdivisions, array = [])
    subdivisions.each do |subdivision|
      array << normalize_subdivision_title(subdivision.title)
      fetch_subdivisions_titles(subdivision.children, array) if subdivision.children
    end

    array
  end

  def fetch_available_cms_navigation(titles, navigation)
    navigation.each do |slug, nav|
      if titles.include?(normalize_subdivision_title(nav.title))
        fetch_available_cms_navigation(titles, nav.children) if nav.children
      else
        navigation.delete(slug)
      end
    end

    navigation
  end

  def navigation_from_cms_by_directory(directory_info, cms_navigation)
    titles = fetch_subdivisions_titles(directory_info)

    fetch_available_cms_navigation(titles, cms_navigation)
  end

  def fetch_navigations_titles(navigation, array = [])
    return array unless navigation

    navigation.each do |_, nav|
      array << normalize_subdivision_title(nav.title)
      fetch_navigations_titles(nav.children, array) if nav.children
    end

    array
  end

  def fetch_available_directory_info(titles, directory_info)
    diff = []
    directory_info.each do |subdivision|
      diff << subdivision unless titles.include?(normalize_subdivision_title(subdivision.title))
    end

    diff
  end

  def navigation_from_directory_by_cms(directory_info, cms_navigation)
    titles = fetch_navigations_titles(cms_navigation)

    fetch_available_directory_info(titles, directory_info)
  end

end
