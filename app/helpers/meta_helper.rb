module MetaHelper

  def canonical_href
    request.path.eql?("/ru") ? '/' : request.path
  end

  def meta_tags
    return '' if @page_meta.blank?

    result =  ''
    result += "<meta name='description' content='#{@page_meta.description}' />\n" if @page_meta.description.present?
    result += "<meta name='keywords' content='#{@page_meta.keywords}' />\n" if @page_meta.keywords.present?
    result += "\n"

    # The Open Graph protocol
    if @page_meta.og_site_name.present?
      result += "<meta property='og:site_name' content='#{@page_meta.og_site_name}' />\n"
    else
      result += "<meta property='og:site_name' content='#{strip_tags(@site_name.try(:content).try(:body)).try(:squish)}' />\n"
    end
    if @page_meta.og_title.present?
      result += "<meta property='og:title' content='#{@page_meta.og_title}' />\n"
    else
      result += "<meta property='og:title' content='#{@page.regions.try(:[], 'content').try(:[], 'part_title').presence || @page_title}' />\n"
    end
    result += "<meta property='og:description' content='#{@page_meta.og_description}' />\n" if @page_meta.og_description.present?
    result += "<meta property='og:description' content='#{@page_meta.description}' />\n" if @page_meta.description.present? && @page_meta.og_description.blank?
    result += "<meta property='og:type' content='#{@page_meta.og_type}' />\n" if @page_meta.og_type.present?
    result += "<meta property='og:url' content='#{request.original_url.to_s.force_encoding('UTF-8')}' />\n"
    result += "<meta property='og:image' content='#{@page_meta.image_url}' />\n" if @page_meta.image_url.present?
    result += "<meta property='og:locale' content='#{@page_meta.og_locale}' />\n" if @page_meta.og_locale.present?
    result += "<meta property='og:locale:alternate' content='#{@page_meta.og_locale_alternate}' />\n" if @page_meta.og_locale_alternate.present?
    result += "\n"

    # Twitter Card
    if @page_meta.twitter_card.present?
      result += "<meta name='twitter:card' content='#{@page_meta.twitter_card}' />\n"
      result += "<meta name='twitter:site' content='#{@page_meta.twitter_site}' />\n"
      result += "<meta name='twitter:creator' content='#{@page_meta.twitter_creator}' />\n"
      if @page_meta.twitter_title.present?
        result += "<meta name='twitter:title' content='#{@page_meta.twitter_title}' />\n"
      else
        result += "<meta name='twitter:title' content='#{@page_title}' />\n"
      end
      result += "<meta name='twitter:description' content='#{@page_meta.twitter_description}' />\n" if @page_meta.twitter_description.present?
      result += "<meta name='twitter:description' content='#{@page_meta.description}' />\n" if @page_meta.description.present? && @page_meta.twitter_description.blank?
      result += "<meta name='twitter:domain' content='#{@page_meta.twitter_domain.presence || request.host}' />\n"
      result += "<meta name='twitter:url' content='#{request.original_url.to_s.force_encoding('UTF-8')}' />\n"
      if @page_meta.image_url.present?
        result += "<meta name='twitter:image' content='#{@page_meta.image_url}' />\n" if @page_meta.twitter_card.present? && @page_meta.twitter_card == 'summary'
        result += "<meta name='twitter:image:src' content='#{@page_meta.image_url}' />\n" if @page_meta.twitter_card.present? && @page_meta.twitter_card == 'summary_large_image'
      end
    end

    result.html_safe
  end

  def meta_social(content)
    return if content.blank?

    result = ''
    result += "<meta property='og:image' content='#{content.content.images.first.url}' /> \n" unless content.content.images.blank?
    result += "<meta name='description' content='#{strip_tags(content.content.annotation)}' />\n" if content.content.annotation.present?
    if content.template == 'youtube_item_part'
      result += Rails.cache.fetch("youtube_large_thumbnail_#{content.content.youtube_code}", expires_in: 1.days) do
        "<meta property='og:image' content='#{youtube_large_thumbnail(content.content.youtube_code)}' /> \n"
      end
    end

    result.html_safe
  end

end
