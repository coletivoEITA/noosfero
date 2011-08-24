require File.dirname(__FILE__) + '/../../../../test/test_helper'

class FormerOptionTest < ActiveSupport::TestCase
  def setup
    @fl = FormerOptionField.create!(:form_field => Enterprise.form, :name => 'option')
  end

  should 'add options to a field' do
    FormerOption.create!(:field => @fl, :name => 'prefeitura')
    FormerOption.create!(:field => @fl, :name => 'empresa')

    assert_equal @fl.options[0].name, 'prefeitura'
    assert_equal @fl.options[1].name, 'empresa'
  end
end
