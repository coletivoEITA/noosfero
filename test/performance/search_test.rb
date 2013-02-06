require 'test_helper'
require 'performance_test_help'

class SearchTest < ActionController::PerformanceTest

  def test_enterprises
    get '/search/enterprises?q=cooperativa'
  end

  def test_products
    get '/search/enterprises?q=banana'
  end

end
