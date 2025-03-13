module WeatherHelper
  # Creates a forecast link for a result location
  def result_link(result_location)
    name = build_name(result_location)
    url = weather_forecast_path latitude: result_location[:latitude],
                                longitude: result_location[:longitude],
                                temperature_unit: "fahrenheit",
                                name: name,
                                data: { turbo_frame: "location_frame" }

    link_to name, url, class: "text-pink-500 hover:text-orange-600 underline cursor-pointer"
  end

  # Builds the result location name to be displayed using all relevant parts.
  def build_name(result_location)
    parts = []

    (1..5).each do |i|
      key = "admin#{i}".to_sym
      break unless result_location.key?(key)

      parts << result_location[key]
    end

    return "#{result_location[:name]}, #{result_location[:country_code]} (#{parts.join(', ')})" if parts.present?

    result_location[:name]
  end
end
