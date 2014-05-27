require_relative 'environment'

include Clockwork
garden = Garden.new GARDEN_LATITUDE, GARDEN_LONGITUDE

every(1.day, 'water_if_needed_daily', at: '22:05') do
  garden.auto_water
end

Clockwork::run

