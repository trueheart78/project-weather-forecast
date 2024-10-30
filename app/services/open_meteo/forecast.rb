class OpenMeteo::Forecast
  BASE_URL = "https://api.open-meteo.com".freeze

  class << self
    def retrieve(latitude, longitude, temperature_unit)
      redis_key = "forecast:#{latitude}:#{longitude}:#{temperature_unit}"

      if cached?(redis_key)
        load_cached_response(redis_key)
      else
        json_raw = retrieve_from_api(latitude, longitude, temperature_unit)

        cache_json(redis_key, json_raw)
        parse_json(json_raw)
      end
    end

    private

    def retrieve_from_api(latitude, longitude, temperature_unit)
      response = perform_api_request(latitude, longitude, temperature_unit)

      raise RuntimeError, "Status Returned: #{response.status}" if response.status != 200

      response.body
    end

    def perform_api_request(latitude, longitude, temperature_unit)
      Faraday.new(
        url: BASE_URL,
        params: {
          latitude: latitude,
          longitude: longitude,
          temperature_unit: temperature_unit
        }.merge(default_params),
        headers: { "Content-Type" => "application/json" }
      ).get("v1/forecast")
    end

    def default_params
      {
        current: "temperature_2m",
        daily: "temperature_2m_max,temperature_2m_min",
        timezone: "GMT",
        forecast_days: 7
      }
    end

    def parse_json(json_raw)
      JSON.parse json_raw, symbolize_names: true
    end

    def cache_json(key, json_raw)
      $redis.multi do
        $redis.set key, json_raw
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
