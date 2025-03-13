class FakeMeteo
  class << self
    def response_json(name)
      {
        results: [
          generate_result(name: name),
          generate_result(name: name)
        ],
        generationtime_ms: 0.62704086
      }
    end

    private

    def generate_result(name)
      name = "Test Name" if name.blank?

      id = rand(1_000_000...10_000_000)
      post_code = rand(1_000...10_000)

      {
        id: id,
        name: "#{name} (id: #{id})",
        latitude: rand(42),
        longitude: rand(42),
        country_code: "US",
        admin1_id: rand(1_000_000...10_000_000),
        admin2_id: rand(1_000_000...10_000_000),
        admin3_id: rand(1_000_000...10_000_000),
        admin1: "State Name",
        admin2: "County Name",
        admin3: "City Name",
        timezone: "America/New_York",
        postcodes: %W[#{post_code}1 #{post_code}2 #{post_code}3],
        country_id: 6252001,
        country: "United States"
      }
    end
  end
end
