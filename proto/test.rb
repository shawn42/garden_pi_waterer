require_relative 'environment'
unless RUNNING_ON_PI
puts "OH NOES, run on Pi please"
end

garden = Garden.new GARDEN_LATITUDE, GARDEN_LONGITUDE
puts "Found your garden at #{GARDEN_LATITUDE}, #{GARDEN_LONGITUDE}"

puts garden.read_light_sensor
#sleep 1
puts garden.read_soil_sensor
#sleep 1
#garden.start_watering
#sleep 3
#garden.stop_watering

