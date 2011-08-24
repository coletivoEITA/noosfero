require File.dirname(__FILE__) + '/../../../../test/test_helper'

class FormerFormFieldTest < ActiveSupport::TestCase
  should 'respond to form' do
    Enterprise.respond_to?(:form)
  end
end
