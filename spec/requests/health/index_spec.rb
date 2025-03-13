require 'rails_helper'

RSpec.describe 'HealthController#show', type: :request do
  before { get '/up' }

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
end
