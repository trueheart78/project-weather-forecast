require 'rails_helper'

RSpec.describe "WeatherController#location", type: :request do
  let(:request_url) { "#{OpenMeteo::Location::BASE_URL}/v1/search?name=#{name}" }
  let(:name) { "90210" }
  let(:response_json) { FakeMeteo::Location.response_json(name) }

  describe "successful requests" do
    before do
      stub_request(:get, request_url).to_return_json(body: response_json)
      get '/weather/location', params: { query: name }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns HTML response" do
      expect(response.content_type).to include("text/html")
    end

    it "includes turbo-frame tag" do
      expect(response.body).to include('turbo-frame')
      expect(response.body).to include('location_results')
    end

    it "displays location results" do
      result = response_json[:results].first
      expect(response.body).to include(CGI.escapeHTML(result[:name]))
      expect(response.body).to include(result[:country])
    end
  end

  describe "caching behavior" do
    it "caches the API response" do
      stub = stub_request(:get, request_url).to_return_json(body: response_json)

      # First request
      get '/weather/location', params: { query: name }
      expect(stub).to have_been_requested.times(1)

      # Second request should use cache
      get '/weather/location', params: { query: name }
      expect(stub).to have_been_requested.times(1)
      expect(response.body).to include('Results from cache')
    end
  end

  describe "error handling" do
    context "when API returns 404" do
      before do
        stub_request(:get, request_url).to_return(status: 404, body: "Not Found")
        get '/weather/location', params: { query: name }
      end

      it "returns http not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "displays error message" do
        expect(response.body).to include('Location not found')
      end
    end

    context "when API returns 500" do
      before do
        stub_request(:get, request_url).to_return(status: 500, body: "Internal Server Error")
        get '/weather/location', params: { query: name }
      end

      it "returns http internal server error" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "displays error message" do
        expect(response.body).to include('Internal server error')
      end
    end

    context "when API times out" do
      before do
        stub_request(:get, request_url).to_timeout
        get '/weather/location', params: { query: name }
      end

      it "returns http gateway timeout" do
        expect(response).to have_http_status(:gateway_timeout)
      end

      it "displays error message" do
        expect(response.body).to include('Gateway timeout')
      end
    end
  end

  describe "input validation" do
    context "when query is empty" do
      before { get '/weather/location', params: { query: "" } }

      it "returns http unprocessable entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "displays validation error message" do
        expect(response.body).to include(CGI.escapeHTML("name can't be blank"))
      end
    end

    context "when query is missing" do
      before { get '/weather/location' }

      it "returns http unprocessable entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "displays validation error message" do
        expect(response.body).to include(CGI.escapeHTML("name can't be blank"))
      end
    end

    context "when query contains special characters" do
      let(:name) { "New York, NY!" }

      before do
        stub_request(:get, request_url).to_return_json(body: response_json)
        get '/weather/location', params: { query: name }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "displays location results" do
        result = response_json[:results].first
        expect(response.body).to include(CGI.escapeHTML(result[:name]))
      end
    end
  end

  describe "rate limiting" do
    context "when API returns 429" do
      before do
        stub_request(:get, request_url).to_return(
          status: 429,
          headers: { "Retry-After" => "60" },
          body: "Too Many Requests"
        )
        get '/weather/location', params: { query: name }
      end

      it "returns http too many requests" do
        expect(response).to have_http_status(:too_many_requests)
      end

      it "displays error message with retry information" do
        expect(response.body).to include('Too many requests')
        expect(response.body).to include('60 seconds')
      end
    end
  end
end
