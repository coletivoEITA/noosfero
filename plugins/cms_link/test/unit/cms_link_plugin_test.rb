require File.dirname(__FILE__) + '/../../../../test/test_helper'

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'cms_link_plugin'

class CmsLinkPluginTest < Test::Unit::TestCase
  def setup
    @cms_link = CmsLinkPlugin.new

  end
  
  should 'return true to stylesheet' do
    assert @cms_link.stylesheet?
  end

  should 'return plugin name' do
    assert_equal CmsLinkPlugin.plugin_name, "CmsLink"
  end

  should 'return link article type' do
    article_type = @cms_link.article_types

    assert_equal article_type[:name], 'Link'
    assert_equal article_type[:type], CmsLinkPluginLink
    assert_equal article_type[:view_path], CmsLinkPlugin.view_path
    assert_equal article_type[:description], CmsLinkPluginLink.description
    assert_equal article_type[:short_description], CmsLinkPluginLink.short_description
    
  end
end
