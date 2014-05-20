require 'clockwork'
require 'pry'
require 'sqlite3'

begin
  require 'pi_piper'
  require "i2c/i2c"
rescue LoadError => ex
  puts 'load error, are you on the Pi?'
  # p ex
end

require 'forecast_io'
ForecastIO.configure do |configuration|
  configuration.api_key = 'e99eac6f544ed1382750c36244e0094e'
end

require_relative 'garden'
