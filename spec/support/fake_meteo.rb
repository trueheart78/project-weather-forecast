class FakeMeteo
  # Generates a random latitude between -90.00 to 90.00
  def self.random_latitude
    (rand * 180 - 90).round(2)
  end

  # Generates a random longitude between -180.00 to 180.00
  def self.random_longitude
    (rand * 360 - 180).round(2)
  end
end
