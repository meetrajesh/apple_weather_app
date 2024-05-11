class HomeController < ApplicationController
  def index
    if params[:address]
      @weather_data = OpenWeatherService.weather_for_given_address(params[:address])
    end
  end
end
