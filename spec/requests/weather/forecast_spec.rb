require 'rails_helper'

RSpec.describe "WeatherController#forecast", type: :request do
  let(:request_url) { "#{OpenMeteo::Location::BASE_URL}/v1/search?name=#{name}" }
  let(:name) { "90210" }
  let(:response_json) { FakeMeteo::Location.response_json(name) }

  before do
    stub_request(:get, request_url).to_return_json(body: response_json)

    get '/weather/location', params: { query: name }
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
end
