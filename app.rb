require_relative 'environment'

include Clockwork
lat = 42.7814
long = -86.1111
garden = Garden.new lat, long

# every(1.day, 'water_if_needed_daily', at: '00:00') do
every(10.seconds, 'water_if_needed_quickly') do
  garden.auto_water
end

Clockwork::run

