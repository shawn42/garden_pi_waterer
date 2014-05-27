class Garden
  WATERING_PIN = 7
  CONFIGS = [ [193, 131], [209, 131] ]
  LIGHT_SENSOR = 0
  MOISTURE_SENSOR = 1
  I2C_DEVICE_ID = 1
  ADC_ADDRESS = 0x48

  def initialize(lat, long)
    @lat = lat
    @long = long
    if RUNNING_ON_PI
      @pin = PiPiper::Pin.new(pin: WATERING_PIN, direction: :out)
      @bus = ::I2C.create("/dev/i2c-1")
    end
    @db = SQLite3::Database.new "garden.db"
    build_missing_tables
    stop_watering
  end

  def read_light_sensor
    read_sensor LIGHT_SENSOR
  end

  def read_moisture_sensor
    read_sensor MOISTURE_SENSOR
  end

  def auto_water
    record_sensor_data
    water unless rain_is_coming?
  end

  private
  def read_sensor(channel)
    return unless RUNNING_ON_PI
    @bus.write(ADC_ADDRESS, I2C_DEVICE_ID, *CONFIGS[channel])
    result = @bus.read(ADC_ADDRESS, 0x02, 0).unpack('CC')
    ((result.first << 8) | (result.last & 0xFF)) >> 4
  end


  def build_missing_tables
    #"SELECT name FROM sqlite_master WHERE type='table' AND name='table_name';"
    rows = @db.execute <<-SQL
      create table if not exists light_readings (
        created_at datetime,
        reading int
      );
    SQL
  end

  def record_sensor_data
    light_reading = read_light_sensor
    @db.execute "INSERT INTO light_readings (created_at, reading)
      VALUES (?,?)", [DateTime.now.to_i, light_reading]
  end

  def water
    start_watering
    sleep watering_duration
    stop_watering
  end

  def watering_duration
    30
  end

  def start_watering
    puts "start watering"
    @pin.on if RUNNING_ON_PI
  end

  def stop_watering
    puts "stop watering"
    @pin.off if RUNNING_ON_PI
  end

  def rain_is_coming?
    forecast = ForecastIO.forecast @lat, @long
    today_and_tomorrow = forecast["daily"]["data"][0..1]
    rain_is_coming = today_and_tomorrow.any?{|d| d["precipType"] == "rain" && 
                                            d["precipProbability"] > 0.5}
  end
end
