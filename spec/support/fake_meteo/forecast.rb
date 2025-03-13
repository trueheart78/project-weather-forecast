class FakeMeteo::Forecast
  def self.generate_body(latitude, longitude, temperature_unit)
    temp_notation = "°C"
    temp_notation = "°F" if temperature_unit == "fahrenheit"

    {
      latitude: latitude,
      longitude: longitude,
      generationtime_ms: 0.0710487365722656,
      utc_offset_seconds: 0,
      timezone: "GMT",
      timezone_abbreviation: "GMT",
      elevation: rand(10...100),
      current_units: {
        time: "iso8601",
        interval: "seconds",
        temperature_2m: temp_notation
      },
      current: {
        time: "2024-10-29T21:30",
        interval: 900,
        temperature_2m: 13.2
      },
      daily_units: {
        time: "iso8601",
        temperature_2m_max: temp_notation,
        temperature_2m_min: temp_notation
      },
      daily: {
        time: [
          Time.now.strftime("%F"),
          1.day.from_now.strftime("%F"),
          2.days.from_now.strftime("%F"),
          3.days.from_now.strftime("%F"),
          4.days.from_now.strftime("%F"),
          5.days.from_now.strftime("%F"),
          6.days.from_now.strftime("%F")
        ],
        temperature_2m_max: [ 15.1, 14.8, 14.1, 12.6, 13.5, 13.8, 12 ],
        temperature_2m_min: [ 12, 9.6, 6.5, 10.4, 10.8, 8.7, 7.6 ]
      }
    }
  end
end
