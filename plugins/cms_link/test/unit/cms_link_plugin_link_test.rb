require File.dirname(__FILE__) + '/../../../../test/test_helper'

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'cms_link_plugin_link'

class CmsLinkPluginLinkTest < Test::Unit::TestCase

  def setup
    @link = CmsLinkPluginLink.new

  end

  should 'return true to link? ' do
    assert @link.link?
  end

  should 'return false to folder? ' do
    assert !@link.folder?
  end

  should 'return link to link_name ' do
    assert_equal CmsLinkPluginLink.icon_name , "link"
  end


end
