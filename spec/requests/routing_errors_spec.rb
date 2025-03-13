require 'rails_helper'

RSpec.describe "Routing Errors", type: :request do
  before { get '/unknown-route-for-testing' }

  it "returns http success" do
    expect(response).to have_http_status(:not_found)
  end
end
