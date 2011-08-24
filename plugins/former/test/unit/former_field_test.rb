require File.dirname(__FILE__) + '/../../../../test/test_helper'

class FormerFieldTest < ActiveSupport::TestCase
  should 'add a field' do
    fl = FormerField.create!(:form_field => Enterprise.form, :name => 'temp field')
    Enterprise.form.fields = [fl]
    assert Enterprise.form.fields == [fl]
  end
end
