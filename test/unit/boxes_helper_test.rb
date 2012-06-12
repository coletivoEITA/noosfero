require File.dirname(__FILE__) + '/../test_helper'

class BoxesHelperTest < ActiveSupport::TestCase

  include BoxesHelper

  should 'calculate CSS class names correctly' do
    assert_equal 'slideshow-block', block_css_class_name(SlideshowBlock.new)
    assert_equal 'main-block', block_css_class_name(MainBlock.new)
  end

end
