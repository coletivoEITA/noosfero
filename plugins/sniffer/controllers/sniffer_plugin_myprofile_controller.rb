class SnifferPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  protect 'edit_profile', :profile

  before_filter :fetch_sniffer_profile

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

    @suppliers_products = @sniffer_profile.suppliers_products
    @buyers_products = @sniffer_profile.buyers_products

    objs = {}
    suppliers = @suppliers_products.group_by{ |p| objs[p.profile_id] ||= enterprise_from_product(p) }.to_hash
    buyers = @buyers_products.group_by{ |p| objs[p.profile_id] ||= enterprise_from_product(p) }
    buyers.each{ |k, v| suppliers[k] ||= [] }
    @enterprises = suppliers.merge(buyers) do |enterprise, suppliers_products, buyers_products|
      {:suppliers_products => suppliers_products, :buyers_products => buyers_products}
    end
  end

  def map_balloon
    @profile = Profile.find params[:id]
    @suppliers_hashes = build_products(params[:data][:suppliers_products])
    @buyers_hashes = build_products(params[:data][:buyers_products])
    render :layout => false
  end

  def my_map_balloon
    @enterprise = profile
    @inputs = @sniffer_profile.profile_input_categories
    @categories = @sniffer_profile.profile_product_categories
    @interests = @sniffer_profile.product_categories
    render :layout => false
  end

  protected

  def fetch_sniffer_profile
    @sniffer_profile = SnifferPluginProfile.find_by_profile_id profile.id
    if @sniffer_profile.nil?
      @sniffer_profile = SnifferPluginProfile.new(:profile => profile, :enabled => true)
      @sniffer_profile.profile = profile
      @sniffer_profile.save!
    end
  end

  def enterprise_from_product(p)
    e = Enterprise.new :identifier => p.profile_identifier, :name => p.profile_name, :lat => p.profile_lat, :lng => p.profile_lng
    e.id = p.profile_id
    e
  end

  def build_products(data)
    return [] if data.blank?
    data.map do |index, attributes|
      product = Product.find attributes['id']
      category = ProductCategory.find attributes['product_category_id']
      my_product = Product.find attributes['my_product_id'] if attributes['my_product_id']
      {:product => product, :category => category, :my_product => my_product, :partial => attributes['view']}
    end
  end

end

