class WeatherController < ApplicationController
  def index
  end

  # GET /weather/location
  def location
    location_json = OpenMeteo::Location.search(params[:query])

    @results = location_json.fetch(:results, [])
    @cached = location_json.fetch(:cached, false)
  end

  # GET /weather/forecast
  def forecast
    @location_name = params[:name] || "Unknown Location"
    @forecast = OpenMeteo::Forecast.retrieve(params[:latitude], params[:longitude], params[:temperature_unit])
    @cached = @forecast.fetch(:cached, false)
  end
end
