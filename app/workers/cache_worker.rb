class CacheWorker

  include Sidekiq::Worker

  attr_accessor :url, :opts

  def perform(url, opts = {}, cache_key = nil)
    @url = url
    @opts = opts
    cache_key = transliterate_cache_key(cache_key || url)
    logger.info "url: #{url}"
    logger.info "params: #{opts}"
    logger.info "cache_key: #{cache_key}"
    logger.info "request status: #{rest_request[:code]}"
    if rest_request[:code] == 200
      Rails.cache.write(cache_key, String.new(rest_request.to_json))
    else
      Rails.cache.delete(cache_key)
    end
  end

  private

  def transliterate_cache_key(cache_key)
    Russian.transliterate URI.decode(cache_key).parameterize('_').gsub('-', '_')
  end

  def rest_request
    @rest_request ||= RestClient::Request.execute(
      method: :get,
      url: url,
      timeout: nil,
      headers: {
        params: opts,
        Accept: 'application/json',
        timeout: nil
      }
    ) do |response, request, result, &block|
      {
        updated_at: Time.zone.now,
        code: response.code,
        headers: response.headers,
        body: response.body.force_encoding('utf-8')
      }
    end
  end

end
