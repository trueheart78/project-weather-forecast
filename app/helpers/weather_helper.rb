module WeatherHelper
  def result_link(result)
    name = build_name(result)
    url = weather_forecast_path(latitude: result[:latitude], longitude: result[:latitude], temperature_unit: "fahrenheit", name: name)

    link_to name, url
  end

  def build_name(result)
    parts = []

    (1..5).each do |i|
      key = "admin#{i}".to_sym
      break unless result.key?(key)

      parts << result[key]
    end

    return "#{result[:name]} (#{parts.join(', ')})" if parts.present?

    result[:name]
  end
end
