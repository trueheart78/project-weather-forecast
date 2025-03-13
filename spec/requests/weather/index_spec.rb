require 'rails_helper'

RSpec.describe "WeatherController#index", type: :request do
  before { get '/' }

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end

  it "contains the expected text" do
    expect(response.body).to include("Weather Forecast")
  end
end
