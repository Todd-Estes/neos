require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObject
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def largest_diameter
    @data.map do |astroid|
      astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def total_asteroids
    @data.count
  end

  def astroid_list
    @data.map do |asteroid|
    {
      name: asteroid[:name],
      diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
      miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
    }
    end
  end




#   def formatted_asteroid_data
#     @data.map do |astroid|
#     {
#       name: astroid[:name],
#       diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
#       miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
#     }
#   end
#
#   {
#     astroid_list: formatted_asteroid_data,
#     biggest_astroid: largest_astroid_diameter,
#     total_number_of_astroids: total_number_of_astroids
#   }
# end
end


class NeoService
  def self.get_data(date)
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
    asteroids_list_data = conn.get('/neo/rest/v1/feed')

    parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]

    NeoSearch.make_neos(parsed_asteroids_data)

    # NearEarthObject.new(parsed_asteroids_data)

end


  class NeoSearch
    def self.make_neos(parsed_asteroids_data)
      NearEarthObject.new(parsed_asteroids_data)
    end
    # def self.find_neos_by_date(date)
    #   NeoService.get_data(date)
    # end


    # def self.find_neos_by_date(date)
    #   conn = Faraday.new(
    #     url: 'https://api.nasa.gov',
    #     params: { start_date: date, api_key: ENV['nasa_api_key']}
    #   )
    #   asteroids_list_data = conn.get('/neo/rest/v1/feed')
    #
    #   parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]


      # parsed_asteroids_data.map do |data|
      #   NearEarthObjects.new(data)

    end
end





# class NearEarthObjects
#   def self.find_neos_by_date(date)
#     conn = Faraday.new(
#       url: 'https://api.nasa.gov',
#       params: { start_date: date, api_key: ENV['nasa_api_key']}
#     )
#     asteroids_list_data = conn.get('/neo/rest/v1/feed')
#
#     parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
#
#
#
#     largest_astroid_diameter = parsed_asteroids_data.map do |astroid|
#       astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
#     end.max { |a,b| a<=> b}
#
#     total_number_of_astroids = parsed_asteroids_data.count
#     formatted_asteroid_data = parsed_asteroids_data.map do |astroid|
#       {
#         name: astroid[:name],
#         diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
#         miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
#       }
#     end
#
#     {
#       astroid_list: formatted_asteroid_data,
#       biggest_astroid: largest_astroid_diameter,
#       total_number_of_astroids: total_number_of_astroids
#     }
#   end
# end
