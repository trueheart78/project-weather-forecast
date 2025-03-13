require "rails_helper"

RSpec.describe OpenMeteo::Forecast do
  describe "BASE_URL" do
    subject { described_class::BASE_URL }
    let(:expected_value) { "https://api.open-meteo.com" }

    it { is_expected.to eq expected_value }
  end

  describe ".retrieve" do
    subject(:retrieve) { described_class.retrieve latitude, longitude, temperature_unit }
    let(:latitude) { FakeMeteo.random_latitude }
    let(:longitude) { FakeMeteo.random_longitude }
    let(:temperature_unit) { %w[fahrenheit celsius].sample }
    let(:request_url) { "#{described_class::BASE_URL}/v1/forecast?current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&forecast_days=7&latitude=#{latitude}&longitude=#{longitude}&temperature_unit=#{temperature_unit}&timezone=GMT" }

    context "when the remote API returns a 200" do
      context "when there are results returned" do
        let(:body_json) { FakeMeteo::Forecast.generate_body latitude, longitude, temperature_unit }

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

        it "returns an the expected array" do
          expect(retrieve).to eq body_json
        end
      end

      context "when called multiple times within 30 minutes" do
        let(:body_json) { FakeMeteo::Forecast.generate_body latitude, longitude, temperature_unit }

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
end
