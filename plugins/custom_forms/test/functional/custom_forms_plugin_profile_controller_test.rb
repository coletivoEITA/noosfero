require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../controllers/custom_forms_plugin_profile_controller'

# Re-raise errors caught by the controller.
class CustomFormsPluginProfileController; def rescue_action(e) raise e end; end

class CustomFormsPluginProfileControllerTest < ActionController::TestCase
  def setup
    @controller = CustomFormsPluginProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @profile = create_user('profile').person
    login_as(@profile.identifier)
    environment = Environment.default
    environment.enable_plugin(CustomFormsPlugin)
  end

  attr_reader :profile

  should 'save submission if fields are ok' do
    form = CustomFormsPlugin::Form.create!(:profile => profile, :name => 'Free Software')
    field1 = CustomFormsPlugin::TextField.create(:name => 'Name', :form => form, :mandatory => true)
    field2 = CustomFormsPlugin::TextField.create(:name => 'License', :form => form)

    assert_difference 'CustomFormsPlugin::Submission.count', 1 do
      post :show, :profile => profile.identifier, :id => form.id, :submission => {field1.id.to_s => 'Noosfero', field2.id.to_s => 'GPL'}
    end
    assert !session[:notice].include?('not saved')
    assert_redirected_to :action => 'show'
  end

  should 'disable fields if form expired' do
    form = CustomFormsPlugin::Form.create!(:profile => profile, :name => 'Free Software', :begining => Time.now + 1.day)
    form.fields << CustomFormsPlugin::TextField.create(:name => 'Field Name', :form => form, :default_value => "First Field")

    get :show, :profile => profile.identifier, :id => form.id

    assert_tag :tag => 'input', :attributes => {:disabled => 'disabled'}
  end

  should 'show expired message' do
    form = CustomFormsPlugin::Form.create!(:profile => profile, :name => 'Free Software', :begining => Time.now + 1.day)
    form.fields << CustomFormsPlugin::TextField.create(:name => 'Field Name', :form => form, :default_value => "First Field")

    get :show, :profile => profile.identifier, :id => form.id

    assert_tag :tag => 'h2', :content => 'Sorry, you can\'t fill this form yet'

    form.begining = Time.now - 2.days
    form.ending = Time.now - 1.days
    form.save

    get :show, :profile => profile.identifier, :id => form.id

    assert_tag :tag => 'h2', :content => 'Sorry, you can\'t fill this form anymore'
  end
end
