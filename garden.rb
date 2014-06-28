class Garden
  WATERING_PIN = 4
  CONFIGS = [ [193, 131], [209, 131] ]
  LIGHT_SENSOR = 0
  MOISTURE_SENSOR = 1
  I2C_DEVICE_ID = 1
  ADC_ADDRESS = 0x48
  STOP_WATERING_STATUS = 0
  START_WATERING_STATUS = 1

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

  def read_soil_sensor
    read_sensor MOISTURE_SENSOR
  end

  def auto_water
    record_sensor_data
    water unless rain_is_coming?
  end

  def rain_is_coming?
    forecast = ForecastIO.forecast @lat, @long
    today_and_tomorrow = forecast["daily"]["data"][0..1]
    puts today_and_tomorrow
    rain_is_coming = today_and_tomorrow.any?{|d| d["precipType"] == "rain" && 
                                            d["precipProbability"] > 0.5}
    puts "rain_is_coming?: #{rain_is_coming}"
    rain_is_coming
  end

  def start_watering
    puts "start watering"
    @db.execute "INSERT INTO watering_updates (created_at, status)
      VALUES (?,?)", [DateTime.now.to_i, START_WATERING_STATUS]
    @pin.on if RUNNING_ON_PI
  end

  def stop_watering
    puts "stop watering"
    @db.execute "INSERT INTO watering_updates (created_at, status)
      VALUES (?,?)", [DateTime.now.to_i, STOP_WATERING_STATUS]
    @pin.off if RUNNING_ON_PI
  end

  def read_sensor(channel)
    return unless RUNNING_ON_PI
    @bus.write(ADC_ADDRESS, I2C_DEVICE_ID, *CONFIGS[channel])
    sleep 0.5
    result = @bus.read(ADC_ADDRESS, 0x02, 0).unpack('CC')
    sleep 0.5
    ((result.first << 8) | (result.last & 0xFF)) >> 4
  end

  def build_missing_tables
    #"SELECT name FROM sqlite_master WHERE type='table' AND name='table_name';"
    @db.execute <<-SQL
      create table if not exists light_readings (
        created_at datetime,
        reading int
      );
    SQL
    @db.execute <<-SQL
      create table if not exists soil_readings (
        created_at datetime,
        reading int
      );
    SQL
    @db.execute <<-SQL
      create table if not exists watering_updates (
        created_at datetime,
        status tinyint
      );
    SQL
  end

  def record_sensor_data
    soil_reading = read_soil_sensor
    puts "SOIL: #{soil_reading}"
    @db.execute "INSERT INTO soil_readings (created_at, reading)
      VALUES (?,?)", [DateTime.now.to_i, soil_reading]
    light_reading = read_light_sensor
    puts "LIGHT: #{light_reading}"
    @db.execute "INSERT INTO light_readings (created_at, reading)
      VALUES (?,?)", [DateTime.now.to_i, light_reading]
  end

  def water
    start_watering
    sleep watering_duration_in_sec
    stop_watering
  end

  def watering_duration_in_sec
    45 * 60
  end

end
