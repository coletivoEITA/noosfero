class SnifferPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  protect 'edit_profile', :profile

  before_filter :fetch_sniffer_profile, :only => [:edit, :search]

  def edit
    if request.post?
      begin
        @sniffer_profile.update_attributes(params[:sniffer])
        @sniffer_profile.enabled = params[:sniffer][:enabled]
        @sniffer_profile.save!
        session[:notice] = @sniffer_profile.enabled ?
          _('Buyer interests published') : _('Buyer interests disabled')
      rescue Exception => exception
        flash[:error] = _('Could not save buyer interests options')
      end
      redirect_to :action => 'edit'
    end
  end

  def product_categories
    @categories = ProductCategory.find(:all, :limit => 20, :conditions => ["name ~* ?", params[:q]])
    respond_to do |format|
      format.html
      format.json { render :json => @categories.collect{ |i| {:id => i.id, :name => i.name} } }
    end
  end

  def search
    self.class.no_design_blocks
    if @sniffer_profile.profile.enterprise?
      @needing_products = @sniffer_profile.needing_products
      @using_products = @sniffer_profile.using_products
      @enterprises = (@needing_products.collect(&:enterprise) + @using_products.collect(&:enterprise)).uniq
    end
  end

  def map_balloon
    params[:np] ||= []
    params[:up] ||= []
    @enterprise = Profile.find(params[:eid].to_i)
    @needing_products = Product.find(params[:np].collect{|i| i.to_i})
    @using_products = Product.find(params[:up].collect{|i| i.to_i})
    render :action => :map_balloon, :layout => false
  end

  protected

  def fetch_sniffer_profile
    @sniffer_profile = SnifferPluginProfile.find_by_profile_id(profile.id)
    if @sniffer_profile.nil?
      @sniffer_profile = SnifferPluginProfile.new(:profile => profile, :enabled => true)
      @sniffer_profile.profile = profile
      @sniffer_profile.save!
    end

    @sniffer_profile
  end

end

