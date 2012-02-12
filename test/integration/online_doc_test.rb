require "#{File.dirname(__FILE__)}/../test_helper"

class OnlineDocTest < ActionController::IntegrationTest

  def test_404_section
    get '/doc/something-very-unlikely'
    assert_response 404
  end

  def test_404_topic
    get '/doc/something-very-unlikely/unexisting-topic'
    assert_response 404
  end

end
