module NavigationHelper

  def render_cms_navigation_with_archive_for(html_navigation, object)
    doc = Nokogiri::HTML::DocumentFragment.parse(html_navigation)
    navigation_title = @navigation_title
    navigation_title = object.navigation_title_of_site_news_list if object.type == 'NewsItemPart'
    target = doc.at("a:contains('#{navigation_title}')")
    archive_statistics = object.archive_statistics
    return html_navigation if target.blank? || archive_statistics.blank?

    show_months = archive_statistics.years.map(&:entries_count).max > 240

    html_archive_class = ['archive', 'js-news-archive']

    html_archive = content_tag :ul, :class => html_archive_class do
      html_years = ''
      active_year = params['parts_params'].try(:[], 'news_list').try(:[], 'interval_year')
      active_year = Date.parse(object.content.since).year.to_s if object.type == 'NewsItemPart'
      news_list_path = request.path
      news_list_path = object.path_to_site_news_list if object.type == 'NewsItemPart'
      archive_statistics.years.each do |year|
        html_years_class = []
        if active_year == year.number.to_s
          html_years_class << 'active'
        else
          html_years_class << 'inactive'
        end
        html_years_class << 'has_children' if show_months
        html_years += content_tag :li, :class => html_years_class do
          path = [news_list_path]
          path << [
            "parts_params[news_list][interval_year]=#{year.number}"
          ]
          html_year = link_to(year.number, path.join('?'))

          if show_months
            active_month = params['parts_params'].try(:[], 'news_list').try(:[], 'interval_month')
            active_month = Date.parse(object.content.since).month.to_s if object.type == 'NewsItemPart'

            html_months_class = ['months']
            html_months_class << 'hidden' if active_year != year.number.to_s

            html_months = content_tag :ul, :class => html_months_class do
              html_month = ''
              year.months.each do |month|
                html_month += content_tag :li, :class => (active_year == year.number.to_s && active_month == month.number.to_s) ? 'active' : nil do
                  path = [news_list_path]
                  path << [
                    "parts_params[news_list][interval_year]=#{year.number}",
                    "parts_params[news_list][interval_month]=#{month.number}"
                  ].join('&')
                  link_to I18n.t('date.month_names')[month.number], path.join('?')
                end
              end

              html_month.html_safe
            end

            html_year += html_months
          end

          html_year.html_safe
        end
      end

      html_years.html_safe
    end

    target.after(html_archive)

    doc.to_html.html_safe
  end

end
