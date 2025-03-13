require 'rails_helper'

RSpec.describe "WeatherController#location", type: :request do
  let(:query) { "90210" }

  before { get '/weather/location', params: { query: query } }

  xit "returns http success" do
    expect(response).to have_http_status(:success)
  end

  # TODO: stub out the
  xit "contains the expected JSON" do
    binding.pry
    expect(response.body).to include("Weather Forecast")
  end
end
