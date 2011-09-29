class SnifferPlugin < Noosfero::Plugin

  def self.plugin_name
    "Sniffer"
  end

  def self.plugin_description
    _("Sniffs opportunities ...")
  end

  def control_panel_buttons
    buttons = [{ :title => _("Enable Buyer Interests"), :icon => 'buyer-interests', :url => {:controller => 'sniffer_plugin_myprofile', :action => 'edit'} }]
    buttons.push( { :title => _("Opportunities Sniffer"), :icon => 'sniff-opportunities', :url => {:controller => 'sniffer_plugin_myprofile', :action => 'search'} } ) if context.profile.enterprise?
    buttons
  end

  def stylesheet?
    true
  end

  def js_files
    ['sniffer.js']
  end

end

Product.has_many :using_products, :through => :inputs, :source => :using_products, :uniq => true
Product.has_many :needing_products, :through => :product_category, :source => :needing_products, :uniq => true
ProductCategory.has_many :using_products, :through => :inputs, :source => :using_products, :uniq => true
ProductCategory.has_many :needing_products, :through => :inputs, :source => :product, :uniq => true
Input.has_many :using_products, :through => :product_category, :source => :products, :uniq => true
Enterprise.has_many :using_products, :through => :products, :source => :using_products, :uniq => true
Enterprise.has_many :needing_products, :through => :products, :source => :needing_products, :uniq => true
Enterprise.has_many :needing_categories, :through => :products, :source => :product_category
