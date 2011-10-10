require File.dirname(__FILE__) + '/../../../../test/test_helper'

class FormerValueTest < ActiveSupport::TestCase
  def setup
    @fl = FormerField.create!(:form_field => Enterprise.form, :name => 'option')
  end

  should 'fill a value of a field' do
    v = FormerValue.create!(:field => @fl, :instance_id => 5, :value => 'blah')
    assert @fl.values[0].value == 'blah'
  end
end
