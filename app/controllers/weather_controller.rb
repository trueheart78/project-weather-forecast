# Walks the user through the location and forecast pages.
class WeatherController < ApplicationController
  def index
  end

  # GET /weather/location
  def location
    @location_json = OpenMeteo::Location.search(params[:query])
    @results = @location_json.fetch(:results, [])
    @cached = @location_json.fetch(:cached, false)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  rescue ArgumentError => e
    @error = e.message
    render :error, status: :unprocessable_entity
  rescue RuntimeError => e
    @error = case
    when e.message.include?("Status Returned: 404")
      "Location not found"
    when e.message.include?("Status Returned: 429")
      @retry_after = 60
      "Too many requests"
    else
      "Internal server error"
    end
    render :error, status: error_status_for(e)
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError
    @error = "Gateway timeout"
    render :error, status: :gateway_timeout
  end

  # GET /weather/forecast
  def forecast
    @location_name = params[:name] || "Unknown Location"
    @forecast = OpenMeteo::Forecast.retrieve(params[:latitude], params[:longitude], params[:temperature_unit])
    @cached = @forecast.fetch(:cached, false)
  end

  private

  def error_status_for(error)
    case
    when error.message.include?("Status Returned: 404")
      :not_found
    when error.message.include?("Status Returned: 429")
      :too_many_requests
    else
      :internal_server_error
    end
  end
end
