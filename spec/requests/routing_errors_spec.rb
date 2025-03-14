require 'rails_helper'

RSpec.describe "Routing Errors", type: :request do
  describe "unknown routes" do
    it "returns http not found for GET requests" do
      get '/unknown-route-for-testing'
      expect(response).to have_http_status(:not_found)
    end

    it "returns http not found for POST requests" do
      post '/unknown-route-for-testing'
      expect(response).to have_http_status(:not_found)
    end

    it "returns http not found for PUT requests" do
      put '/unknown-route-for-testing'
      expect(response).to have_http_status(:not_found)
    end

    it "returns http not found for DELETE requests" do
      delete '/unknown-route-for-testing'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "special route cases" do
    it "handles routes with special characters" do
      get '/route-with-special-chars%21%40%23%24%25%5E%26*%28%29'
      expect(response).to have_http_status(:not_found)
    end

    it "handles routes with parameters" do
      get '/route-with-params/123/456'
      expect(response).to have_http_status(:not_found)
    end

    it "handles very long routes" do
      get '/a' * 1000
      expect(response).to have_http_status(:not_found)
    end

    it "handles routes with different content types" do
      get '/unknown-route', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
