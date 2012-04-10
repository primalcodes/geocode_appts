require 'rubygems'
require 'geocoder'
require 'csv'

def geocode_address(row)
  address = "#{row['address']} #{row['city']}, #{row['state']} #{row['zip']}"
  puts address
  Geocoder.coordinates(address)
end

#===========================================
# Create geocoded file
#===========================================
counter = 0
File.open("file_out.csv", "w") do |f|
  f.puts "agent, latitude, longitude"
  # agent,date,company,address,city,state,zip
  CSV.foreach("file_in.csv", :headers=>true) do |row|
    gc = geocode_address(row)
    
    counter += 1
    if counter >5
      counter = 0
      sleep(3)
    end
    
    begin
      f.puts "#{row['agent']}, #{gc.first}, #{gc.last}"
    rescue
      puts "Could not find coordinates for #{row.inspect}"    
    end
  end
end
# ['Maroubra Beach', -33.950198, 151.259302, 1]


#[#<Geocoder::Result::Google:0x0000010113a0e0 @data={"address_components"=>[{"long_name"=>"108", "short_name"=>"108", "types"=>["street_number"]}, {"long_name"=>"N Main St", "short_name"=>"N Main St", "types"=>["route"]}, {"long_name"=>"Sherburne", "short_name"=>"Sherburne", "types"=>["locality", "political"]}, {"long_name"=>"Sherburne", "short_name"=>"Sherburne", "types"=>["administrative_area_level_3", "political"]}, {"long_name"=>"Chenango", "short_name"=>"Chenango", "types"=>["administrative_area_level_2", "political"]}, {"long_name"=>"New York", "short_name"=>"NY", "types"=>["administrative_area_level_1", "political"]}, {"long_name"=>"United States", "short_name"=>"US", "types"=>["country", "political"]}, {"long_name"=>"13460", "short_name"=>"13460", "types"=>["postal_code"]}], "formatted_address"=>"108 N Main St, Sherburne, NY 13460, USA", "geometry"=>{"bounds"=>{"northeast"=>{"lat"=>42.68864910000001, "lng"=>-75.5028224}, "southwest"=>{"lat"=>42.688644, "lng"=>-75.50284409999999}}, "location"=>{"lat"=>42.688644, "lng"=>-75.50284409999999}, "location_type"=>"RANGE_INTERPOLATED", "viewport"=>{"northeast"=>{"lat"=>42.6899955302915, "lng"=>-75.5014842697085}, "southwest"=>{"lat"=>42.68729756970851, "lng"=>-75.5041822302915}}}, "types"=>["street_address"]}>]