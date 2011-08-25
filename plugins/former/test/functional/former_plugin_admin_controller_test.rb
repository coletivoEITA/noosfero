require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/former_plugin_admin_controller'
# Re-raise errors caught by the controller.
class FormerPluginAdminController; def rescue_action(e) raise e end; end

class FormerPluginAdminControllerTest < Test::Unit::TestCase
  fixtures :environments

  def setup
    @controller = FormerPluginAdminController.new
    @request    = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(true)
    @response   = ActionController::TestResponse.new
    @profile = create_user_with_permission('testinguser', 'post_content')
    
    @p = Profile.find_by_name('testinguser')
    Environment.default.add_admin(@p)
    
    login_as :testinguser
    @controller.stubs(:user).returns(@profile)
  end

  attr_reader :profile

  def test_local_files_reference
    assert_local_files_reference :get, :index, :profile => profile.identifier
  end

  def test_valid_xhtml
    assert_valid_xhtml
  end

  should 'add new field form' do

    status_msg = _('Field was created')
    attr = {:identifier => :fields, :name => 'Test form'}
    form = FormerPluginFormField.create!(attr)
    last_field = FormerPluginOptionField.create!(:form => form)
   
    post :add_new_field, :profile => profile.identifier, :form_identifier => :fields
        
    assert_equal ({:field_id => last_field.id + 1, :status_msg => status_msg}.to_json), @response.body

    assert FormerPluginOptionField.find(last_field.id + 1).id
  end
  
  should 'add new option' do

    status_msg = _('Option was created') 
    attr = {:identifier => :fields, :name => 'Test form'}
    form = FormerPluginFormField.create!(attr)
    field = FormerPluginOptionField.create!(:form => form)
    last_option = field.options.create!(:name => '');

    post :add_new_option, :field_id => field.id
        
    assert_equal ({:option_id => last_option.id + 1, :status_msg => status_msg}.to_json) , @response.body

    assert FormerPluginOption.find(last_option.id + 1).id

  end

  should  'save change options'do
     status_msg = _('Fields were saved')
     attr = {:identifier => 'form_field', :name => 'Test form'}
     form = FormerPluginFormField.create!(attr)
     field = FormerPluginOptionField.create!(:form => form)
     option = field.options.create!(:name => '');
     forms  = {}
     
     forms["form_field"] = {}
     forms["form_field"]["fields"] = {}
     forms["form_field"]["fields"]["#{field.id}"] = {}
     forms["form_field"]["fields"]["#{field.id}"]["name"] = "Title of Field"
     forms["form_field"]["fields"]["#{field.id}"]["required"] = nil
     forms["form_field"]["fields"]["#{field.id}"]["options"] = {}

     post :save_option, :forms => forms

     assert_equal ({:success => true , :status_msg => status_msg}.to_json) , @response.body

     assert_equal "Title of Field", FormerPluginOptionField.find_by_id(field.id).name

  end

  should  'remove option' do
    status_msg = _('Option was deleted')
    attr = {:identifier => :fields, :name => 'Test form'}
    form = FormerPluginFormField.create!(attr)
    field = FormerPluginOptionField.create!(:form => form)
    option = field.options.create!(:name => '');

    post :remove, :id => option.id, :type => 'field_option'

    assert_equal ({:status_msg => status_msg}.to_json) , @response.body

    options = field.options.all

    assert options.length == 0
  end

   should  'remove field' do
    status_msg = _('Field was deleted')
    attr = {:identifier => :fields, :name => 'Test form'}
    form = FormerPluginFormField.create!(attr)
    field = FormerPluginOptionField.create!(:form => form)
    
    post :remove, :id => field.id, :type => 'field'

    assert_equal ({:status_msg => status_msg}.to_json) , @response.body

    fields = FormerPluginOptionField.all

    assert fields.length == 0
  end

end