class OpenMeteo::Location
  BASE_URL = "https://geocoding-api.open-meteo.com".freeze

  class << self
    def search(name)
      raise ArgumentError, "name can't be blank" if name.blank?

      redis_key = "location:#{name}"
      if cached?(redis_key)
        load_cached_response(redis_key)
      else
        json_raw = retrieve_from_api(name)

        cache_body(redis_key, json_raw)
        parse_json(json_raw)
      end
    end

    private

    def retrieve_from_api(name)
      response = perform_api_search_request(name)

      raise RuntimeError, "Status Returned: #{response.status}" if response.status != 200

      response.body
    end

    def perform_api_search_request(name)
      Faraday.new(
        url: BASE_URL,
        params: { name: name },
        headers: { "Content-Type" => "application/json" }
      ).get("v1/search")
    end

    def parse_json(body)
      JSON.parse(body, symbolize_names: true)
    end

    def cache_body(key, body)
      $redis.multi do
        $redis.set key, body
        $redis.expire key, 30.minutes.to_i
      end
    end

    def cached?(key)
      $redis.exists? key
    end

    def load_cached_response(key)
      json_raw = $redis.get(key)

      parse_json(json_raw).tap do |j|
        j[:cached] = true
      end
    end
  end
end
