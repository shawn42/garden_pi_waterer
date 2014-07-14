require_relative 'environment'
class ForecastMe
  def forecast(lat, long)
    forecast = ForecastIO.forecast lat, long

    # today_and_tomorrow = forecast["daily"]["data"][0..1]
    # puts today_and_tomorrow
    # rain_is_coming = today_and_tomorrow.any?{|d| d["precipType"] == "rain" && 
    #                                         d["precipProbability"] > 0.5}
    # puts "rain_is_coming?: #{rain_is_coming}"
    # rain_is_coming
  end

end

garden = Garden.new(GARDEN_LATITUDE, GARDEN_LONGITUDE)
#ap ForecastMe.new.forecast(GARDEN_LATITUDE,GARDEN_LONGITUDE)
# ap Garden::RAIN_THRESHOLD
# ap Garden.new(GARDEN_LATITUDE, GARDEN_LONGITUDE).rain_is_coming?
ap garden.water_for_target(1.5, 0.0358 * 0.78)
puts
ap garden.water_for_target(1.5, 0.0016 * 0.23)

