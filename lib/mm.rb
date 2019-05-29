require "mm/version"
require 'erv'
require 'geo/coord'
require 'ruby_kml'


module Mm
  class Error < StandardError; end
  # Your code goes here...
  # from github put the link here
  class RandomWalk

    def self.one_dimension(limits, array_length, step = 1)
      starting_point = Random.rand(limits)
      output_array = [starting_point]
      (array_length - 1).times do
        add_or_subtract = Random.rand(-step..step)
        end_point = output_array.last + add_or_subtract
        if end_point <= limits.max && end_point >= limits.min
          output_array << end_point
        else
          output_array << output_array.last
        end
      end
      return output_array
    end

    def self.two_dimension(array_length, step = 1, starting_x = 0, starting_y = 0)
      x = Array.new(array_length, 0)
      y = Array.new(array_length, 0)
      x[0] = starting_x
      y[0] = starting_y
      (array_length - 1).times do |i|
        val = Random.rand(1..4)
        case val
        when 1
          x[i] = x[i -1] + 1
          y[i] = y[i - 1] 
        when 2 
          x[i] = x[i - 1] - 1
          y[i] = y[i - 1] 
        when 3 
          x[i] = x[i - 1] 
          y[i] = y[i - 1] + 1
        else 
          x[i] = x[i - 1] 
          y[i] = y[i - 1] - 1
        end
      end
      return [x,y]
    end

    def self.two_latitude_longitude(array_length, starting_location)
      starting_location = starting_location
      gaussian_erv = ERV::RandomVariable.new(distribution: :gaussian ,args: { mean: 0.00005, sd: 0.00005 })
      lats = [starting_location.lat]
      lons = [starting_location.lon]
      positions = []
      m1 = rand >= 0.5 ? 1 : -1
      m2 = rand >= 0.5 ? 1 : -1
      (array_length - 1).times do |i|
        r = gaussian_erv.sample
        val = Random.rand(0..2)
        case val
        when 0
          lats[i] = (lats[i -1] + r * m1)
          lons[i] = lons[i-1]
        when 1
          lats[i] = lats[i -1]
          lons[i] = (lons[i-1] + r * m2)
        else
          lats[i] = lats[i -1]
          lons[i] = (lons[i-1] + r * m2)
        end
        positions << Geo::Coord.new(lats[i], lons[i])
        end
      return positions
    end
  end

  
  class Helper
    def self.coords_to_kml(filename, coords)
      kml = KMLFile.new()
      folder = KML::Folder.new(:name => "#{filename}")
      coords.length.times do |i|
        folder.features << KML::Placemark.new(
          :name => i,
          :geometry => KML::Point.new(:coordinates => {:lat => coords[i].lat, :lng => coords[i].lon})
        )
      end
      kml.objects << folder
      puts kml.render
      kml.save(filename)
    end
  end


  class Test
    def self.test_helper()
      g = Geo::Coord.new(50.004444, 36.231389)
      coords = RandomWalk.two_latitude_longitude(5000, g)
      Helper.coords_to_kml("test.kml", coords)
    end
  end

# module ending
end
