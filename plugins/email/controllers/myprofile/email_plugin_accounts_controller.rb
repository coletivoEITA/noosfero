class EmailPluginAccountsController < MyProfileController

  no_design_blocks

  def edit
    @account = if (id = params[:account].delete(:id)) == 'new' then EmailPlugin::Account.new :profile => profile else EmailPlugin::Account.find id end
    @account.update_attributes! params[:account]

    # change to depend from where it comes
    redirect_to :controller => :email_plugin_home, :action => :index
  end

end
