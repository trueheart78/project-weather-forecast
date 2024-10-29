require "rails_helper"

RSpec.describe OpenMeteo::Forecast do
  describe "BASE_URL" do
    subject { described_class::BASE_URL }
    let(:expected_value) { "https://api.open-meteo.com" }

    it { is_expected.to eq expected_value }
  end

  describe ".retrieve" do
    subject(:retrieve) { described_class.retrieve latitude, longitude, temperature_unit }
    let(:latitude) { random_latitude }
    let(:longitude) { random_longitude }
    let(:temperature_unit) { %w[fahrenheit celsius].sample }

    let(:latitude) { random_latitude }
    let(:longitude) { random_longitude }
    let(:request_url) { "#{described_class::BASE_URL}/v1/forecast?current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&forecast_days=7&latitude=#{latitude}&longitude=#{longitude}&temperature_unit=#{temperature_unit}&timezone=GMT" }

    context "when the remote API returns a 200" do
      context "when there are results returned" do
        let(:body_json) { generate_body latitude, longitude, temperature_unit }

        before do
          stub_request(:get, request_url).to_return_json(body: body_json)
        end

        it "returns the expected results" do
          expect(retrieve).to eq body_json
        end
      end

      context "when there are no results returned" do
        let(:body_json) do
          {
            generationtime_ms: 0.62704086
          }
        end

        before do
          stub_request(:get, request_url).to_return_json(body: body_json)
        end

        it "returns an the expected  array" do
          expect(retrieve).to eq body_json
        end
      end

      context "when called multiple times within 30 minutes" do
        let(:body_json) { generate_body latitude, longitude, temperature_unit }

        it "caches the API call" do
          stub = stub_request(:get, request_url).to_return_json(body: body_json)

          first_json = described_class.retrieve(latitude, longitude, temperature_unit)
          second_json = described_class.retrieve(latitude, longitude, temperature_unit)

          expect(stub).to have_been_requested.times(1)

          expect(first_json.key?(:cached)).to eq false
          expect(second_json.key?(:cached)).to eq true
        end
      end
    end

    context "when the remote API does not return a 200" do
      # TODO: sort out what the error name should be
      let(:expected_error) { RuntimeError }

      before do
        stub_request(:get, request_url).to_return(status: 404, body: "Not Found")
      end

      it "raises the expected error" do
        expect { retrieve }.to raise_error(expected_error)
      end
    end
  end

  def generate_body(latitude, longitude, temperature_unit)
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

  # Generates a random latitude between -90.00 to 90.00
  def random_latitude
    (rand * 180 - 90).round(2)
  end

  # Generates a random longitude between -180.00 to 180.00
  def random_longitude
    (rand * 360 - 180).round(2)
  end
end
