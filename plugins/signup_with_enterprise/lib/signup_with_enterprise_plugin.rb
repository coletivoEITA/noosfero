class SignupWithEnterprisePlugin < Noosfero::Plugin

  def self.plugin_name
    "Signup with Enterprise"
  end

  def self.plugin_description
    _("Signup in two steps creating or linking the user to an enterprise.")
  end

  def account_controller_filters
    [{
      :type => 'before_filter',
      :method_name => 'signup_with_enteprise_plugin',
      :options => {:only => :signup},
      :block => proc do
        redirect_to :controller => :signup_with_enterprise_plugin, :action => :signup
      end
    }]
  end

end
