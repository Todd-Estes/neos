require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test

  def test_a_date_returns_a_list_of_neos
    results = NeoService.get_data('1999-03-21')

    # results = NeoSearch.find_neos_by_date('1999-03-21')
    assert_equal '66253 (1999 GT3)', results.astroid_list[0][:name]
  end
end


#   def test_a_date_returns_a_list_of_neos
#     results = NearEarthObjects.find_neos_by_date('2019-03-30')
#     assert_equal '(2011 GE3)', results[:astroid_list][0][:name]
#   end
# end
