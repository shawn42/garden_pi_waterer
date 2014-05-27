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
  # please change this before using
  configuration.api_key = 'e99eac6f544ed1382750c36244e0094e'
end
# Holland, MI
GARDEN_LATITUDE = 42.7814
GARDEN_LONGITUDE = -86.1111

require_relative 'garden'
