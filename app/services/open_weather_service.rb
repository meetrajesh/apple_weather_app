class OpenWeatherService
  include HTTParty

  WEATHER_BASE_URL = "https://api.openweathermap.org/data/2.5/weather".freeze
  CACHE_DURATION = 30.minutes.freeze

  class << self
    def weather_for_given_address(address)
      address.strip!
      zip_code = address.match(/(, )?([0-9]{5})$/)&.[](2)
      cache_key = zip_code.present? ? zip_code : address

      # check redis cache first
      cached_response = REDIS.get(cache_key)
      return JSON.parse(cached_response) if cached_response.present?

      response = HTTParty.get(WEATHER_BASE_URL + "?q=#{address}&appid=#{ENV['OPEN_WEATHER_API_KEY']}&units=imperial")
      parsed_data = JSON.parse(response.body)

      data = format_data(parsed_data)
      cache_data(cache_key, data)
    end

    private def format_data(parsed_data)
      if parsed_data["message"]
        # error state
        return {error: true, message: parsed_data["message"]}.with_indifferent_access
      end

      data = {
        temp: parsed_data["main"]["temp"],
        high: parsed_data["main"]["temp_max"],
        low: parsed_data["main"]["temp_min"],
        description: parsed_data["weather"][0]["main"] + ", " + parsed_data["weather"][0]["description"],
      }.with_indifferent_access
    end

    private def cache_data(cache_key, data)
      data['fetch_time'] = Time.now.to_s
      REDIS.set(cache_key, data.to_json)
      REDIS.expire(cache_key, CACHE_DURATION)
      data
    end
  end
end
