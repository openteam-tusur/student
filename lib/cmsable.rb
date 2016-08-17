require 'active_support/concern'
require 'rack/cache'
require 'rest-client'
require 'restclient/components'

module Cmsable

  extend ActiveSupport::Concern

  included do
    before_action :prepare_locale
    before_action :detect_robots_in_development if Rails.env.development?
    before_action :check_country
    before_action :load_cms_data
  end

  private

  def prepare_locale
    locale = request.path.split('/').second.to_s.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ? locale : :ru
  end

  def check_country
    return unless request.fullpath.match(/^\/$/)

    return if remote_ip == '127.0.0.1' || request.user_agent.to_s.match(/\(.*https?:\/\/.*\)/)

    geo_data = GeoIP.new(Rails.root.join('data', 'GeoLiteCity.dat'))

    country =
      request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first.to_s.upcase.presence ||
      geo_data.city(remote_ip).try(:country_code2)
    Rails.logger.info "Country: #{country}"
    timezone = geo_data.city(remote_ip).try(:timezone)
    Rails.logger.info "Timezone: #{timezone}"
    redirect_to '/en' if country != 'RU' && I18n.locale != :en
  end

  def remote_ip
    request.remote_ip || nil
  end

  def load_cms_data
    render file: "#{Rails.root}/public/404",
           formats: [:html],
           layout: false,
           status: 404 and return if rest_request_status == 404

    page_regions.each do |region|
      eval "@#{region} = page.regions.#{region}"
    end

    @site_title = @site_name.try(:content).try(:body) || 'ТУСУР'
    @page_title = page.title
    @alternative_title = page.alternative_title
    @navigation_title = page.navigation_title
    @page_meta = page.meta
    @link_to_json = remote_url

    render "templates/#{page.template}" unless page.template == 'on_client'
  end

  def detect_robots_in_development
    puts "\n\n"
    puts "DEBUG --->"
    puts "UserAgent: #{request.user_agent.to_s}"
    puts "Current locale: #{I18n.locale}"
    puts "Params: #{params}"
    puts "<---"
    puts "\n"

    render nothing: true, status: :forbidden and return if request.user_agent.to_s.match(/\(.*https?:\/\/.*\)/)
  end

  def remote_url
    raise 'Override me'
  end

  def cms_address
    @cms_address ||= "#{Settings['cms.url']}/nodes/#{Settings['cms.site_slug']}"
  end

  def rest_request
    RestClient.enable Rack::CommonLogger
    RestClient.enable Rack::Cache,
      metastore: "file:#{Rails.root.join('tmp/rack-cache/meta')}",
      entitystore: "file:#{Rails.root.join('tmp/rack-cache/body')}",
      verbose: true

    @rest_request ||= RestClient::Request.execute(
      method: :get,
      url: remote_url,
      timeout: nil,
      headers: {
        Accept: 'application/json',
        timeout: nil
      }
    ) do |response, request, result, &block|
      begin
        {
          updated_at: Time.zone.now,
          code: response.code,
          headers: response.headers,
          body: response.body.force_encoding('utf-8')
        }
      rescue
        {
          updated_at: Time.zone.now,
          code: 404,
          headers: nil,
          body: ''
        }
      end
    end
  end

  def transliterate_remote_url
    Russian.transliterate URI.decode(remote_url).parameterize('_').gsub('-', '_')
  end

  def cache_timeout
    return 1.minutes if Rails.env.development?
    return 5.minutes if Rails.env.production?
  end

  def load_rest_request_json
    if (defined?(request) && request.host.match(Settings['app.nocache_host'].to_s)) || Rails.env.development?
      result = String.new(rest_request.to_json)
    else
      result = Rails.cache.fetch(transliterate_remote_url) do
        String.new(rest_request.to_json)
      end
      if Time.zone.now - DateTime.parse(JSON.load(result).try(:[], 'updated_at')) > cache_timeout
        CacheWorker.perform_async(remote_url)
      end
    end

    JSON.load result rescue {}
  end

  def rest_request_json
    @rest_request_json ||= load_rest_request_json
  end

  def rest_request_status
    @rest_request_status ||= rest_request_json['code']
  end

  def rest_request_headers
    @rest_request_headers ||= rest_request_json['headers']
  end

  def rest_request_body
    @rest_request_body ||= rest_request_json['body']
  end

  def page_regions
    @page_regions ||= page.regions.keys
  end

  def page
    @page ||= Hashie::Mash.new(request_json).page
  end

  def request_json
    @request_json ||= begin
                        JSON.load rest_request_body
                      rescue
                        raise 'Response is not a JSON'
                      end
  end

end
