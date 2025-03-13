require "rails_helper"

RSpec.describe OpenMeteo::Location do
  describe "BASE_URL" do
    subject { described_class::BASE_URL }
    let(:expected_value) { "https://geocoding-api.open-meteo.com" }

    it { is_expected.to eq expected_value }
  end

  describe ".search" do
    subject(:search) { described_class.search name }

    context "when the name is provided" do
      let(:name) { "Test City, USA" }
      let(:request_url) { "#{described_class::BASE_URL}/v1/search?name=#{name}" }

      context "when the remote API returns a 200" do
        context "when there are results returned" do
          let(:response_json) { FakeMeteo::Location.response_json(name) }

          before do
            stub_request(:get, request_url).to_return_json(body: response_json)
          end

          it "returns the expected results" do
            expect(search).to eq response_json
          end
        end

        context "when called multiple times within 30 minutes" do
          let(:response_json) { FakeMeteo::Location.response_json(name) }

          it "caches the API call" do
            stub = stub_request(:get, request_url).to_return_json(body: response_json)

            first_json = described_class.search(name)
            second_json = described_class.search(name)

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
          expect { search }.to raise_error(expected_error)
        end
      end
    end

    context "when the name is empty" do
      let(:name) { "" }

      it "raises an argument error" do
        expect { search }.to raise_error ArgumentError, "name can't be blank"
      end
    end

    context "when the name is nil" do
      let(:name) { nil }

      it "raises an argument error" do
        expect { search }.to raise_error ArgumentError, "name can't be blank"
      end
    end
  end
end
