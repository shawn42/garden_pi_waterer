require_relative 'environment'

include Clockwork
garden = Garden.new GARDEN_LATITUDE, GARDEN_LONGITUDE
puts "Found your garden at #{GARDEN_LATITUDE}, #{GARDEN_LONGITUDE}"

every(1.day, 'water_if_needed_daily', at: '9:00', thread: true) do
  garden.auto_water
end
every(5.minutes, 'record_readings') do
  garden.record_sensor_data
end

Clockwork::run

