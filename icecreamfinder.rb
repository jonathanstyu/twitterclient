require 'nokogiri'
require 'addressable/uri'
require 'rest-client'
require 'json'

google_request = Addressable::URI.new(
  scheme: "http",
  host: "maps.googleapis.com",
  path: "maps/api/geocode/json",
  query_values: {
    address: "160 Folsom Street, San Francisco, CA 94105",
    sensor: "false"
  }
).to_s

response = RestClient.get(google_request)

parsed = JSON.parse(response)

lati = parsed['results'].first['geometry']['location']['lat']
longt = parsed['results'].first['geometry']['location']['lng']

places_request = Addressable::URI.new(
  scheme: "https",
  host: "maps.googleapis.com",
  path: "maps/api/place/nearbysearch/json",
  query_values: {
    location: "#{lati},#{longt}",
    radius: 500,
    keyword: "ice cream",
    key: "AIzaSyAZjF29aJ-cYW0HryKXOkT5eJizUd7Ln78",
    sensor: "false"
  }
).to_s

places_response = JSON.parse(RestClient.get(places_request))

places_response["results"].each do |result|
  # p result
  p result['name']
  p result['rating']
  p result['vicinity']
  ice_lat = result['geometry']['location']['lat']
  ice_lng = result['geometry']['location']['lng']

  dir_req = Addressable::URI.new(
    scheme: "https",
    host: "maps.googleapis.com",
    path: "maps/api/directions/json",
    query_values: {
      origin: "#{lati},#{longt}",
      destination: "#{ice_lat},#{ice_lng}",
      sensor: "false"
    }
  ).to_s

  directions = JSON.parse(RestClient.get(dir_req))
  html_instructions = []
  directions['routes'].first['legs'].first['steps'].each do |set|
    html_instructions << Nokogiri::HTML(set['html_instructions']).text
  end

  p html_instructions

end