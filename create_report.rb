require 'rubygems'
require 'csv'
require 'erb'

#===============================================
# Create static file output
#===============================================
def create_map(agent, locations)
  template = ERB.new File.read("map_template.html")
  @agent = agent

  i = 1
  @locations = []
  @center_map_coords = "#{locations.first.first}, #{locations.first.last}"
  locations.each do |loc|
    @locations << "['', #{loc.first}, #{loc.last}, #{i}]"
    i+=1
  end

  File.open("output/#{agent}.html", "w") do |f|   
    f.puts template.result(binding)
  end
end

prev_agent = nil
locations = []
CSV.foreach("file_out.csv", :headers=>true) do |row|
  if row['agent'].eql?(prev_agent)
    locations << [row[' latitude'], row[' longitude']]
  else
    create_map(prev_agent, locations) unless prev_agent.nil?
    prev_agent = row['agent']
    locations = [[row[' latitude'], row[' longitude']]]
  end
end
create_map(prev_agent, locations) unless prev_agent.nil?