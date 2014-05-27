require 'clockwork'
require 'pry'
require 'sqlite3'

RUNNING_ON_PI = RbConfig::CONFIG['rubyarchdir'] =~ /^arm/
if RUNNING_ON_PI
  require 'pi_piper'
  require "i2c/i2c"
end

require 'forecast_io'
ForecastIO.configure do |configuration|
  configuration.api_key = ENV['FORECAST_IO_API_KEY']
end
GARDEN_LATITUDE = ENV['GARDEN_LATITUDE']
GARDEN_LONGITUDE = ENV['GARDEN_LONGITUDE']

require_relative 'garden'
