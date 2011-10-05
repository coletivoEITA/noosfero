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

  def self.ext
    Product.named_scope :suppliers_products, lambda { |enterprise|
      km_lat, km_lng = 111.2, 85.3
      { :select => "DISTINCT products_2.id, products_2.name, products.id as my_product_id, products.name as my_product_name,
        profiles.id as profile_id, profiles.identifier as profile_identifier, profiles.name as profile_name, profiles.lat as profile_lat, profiles.lng as profile_lng,
        inputs.product_category_id, categories.name as product_category_name,
        'supplier_product' as view,
        SQRT( POW((#{km_lat} * (#{enterprise.lat} - profiles.lat)), 2) + POW((#{km_lng} * (#{enterprise.lng} - profiles.lng)), 2)) AS profile_distance",
      :joins => "INNER JOIN inputs ON ( products.id = inputs.product_id )
        INNER JOIN categories ON ( inputs.product_category_id = categories.id )
        INNER JOIN products products_2 ON ( categories.id = products_2.product_category_id )
        INNER JOIN profiles ON ( profiles.id = products_2.enterprise_id )",
      :conditions => "(products.enterprise_id = #{enterprise.id} )" }
    }

    Product.named_scope :buyers_products, lambda { |enterprise|
      km_lat, km_lng = 111.2, 85.3
      { :select => "DISTINCT products.id, products.name, products_2.id as my_product_id, products_2.name as my_product_name,
        profiles.id as profile_id, profiles.identifier as profile_identifier, profiles.name as profile_name, profiles.lat as profile_lat, profiles.lng as profile_lng,
        inputs.product_category_id, categories.name as product_category_name,
        'buyer_product' as view,
        SQRT( POW((#{km_lat} * (#{enterprise.lat} - profiles.lat)), 2) + POW((#{km_lng} * (#{enterprise.lng} - profiles.lng)), 2)) AS profile_distance",
      :joins => "INNER JOIN inputs ON ( products.id = inputs.product_id )
        INNER JOIN categories ON ( inputs.product_category_id = categories.id )
        INNER JOIN products products_2 ON ( categories.id = products_2.product_category_id )
        INNER JOIN profiles ON ( profiles.id = products.enterprise_id )",
      :conditions => "products_2.enterprise_id = #{enterprise.id}" }
    }

    Product.named_scope :interests_suppliers_products, lambda { |profile|
      km_lat, km_lng = 111.2, 85.3
      { :from => "sniffer_plugin_profiles sniffer",
      :select => "DISTINCT products.id, products.name,
        profiles.id as profile_id, profiles.identifier as profile_identifier, profiles.name as profile_name, profiles.lat as profile_lat, profiles.lng as profile_lng,
        categories.id as product_category_id, categories.name as product_category_name,
        'interest_supplier_product' as view,
        SQRT( POW((#{km_lat} * (#{profile.lat} - profiles.lat)), 2) + POW((#{km_lng} * (#{profile.lng} - profiles.lng)), 2)) AS profile_distance",
      :joins => "INNER JOIN sniffer_plugin_opportunities as op ON ( sniffer.id = op.profile_id AND op.opportunity_type = 'ProductCategory' )
        INNER JOIN categories categories ON ( op.opportunity_id = categories.id )
        INNER JOIN products ON ( products.product_category_id = categories.id )
        INNER JOIN profiles ON ( products.enterprise_id = profiles.id )",
      :conditions => "sniffer.enabled = true AND sniffer.profile_id = #{profile.id} AND products.enterprise_id <> #{profile.id}" }
    }

    Product.named_scope :interests_buyers_products, lambda { |profile|
      km_lat, km_lng = 111.2, 85.3
      { :select => "DISTINCT products.id, products.name,
        profiles.id as profile_id, profiles.identifier as profile_identifier, profiles.name as profile_name, profiles.lat as profile_lat, profiles.lng as profile_lng,
        categories.id as product_category_id, categories.name as product_category_name,
        'interest_buyer_product' as view,
        SQRT( POW((#{km_lat} * (#{profile.lat} - profiles.lat)), 2) + POW((#{km_lng} * (#{profile.lng} - profiles.lng)), 2)) AS profile_distance",
      :joins => "INNER JOIN categories ON ( categories.id = products.product_category_id )
        INNER JOIN sniffer_plugin_opportunities as op ON ( categories.id = op.opportunity_id AND op.opportunity_type = 'ProductCategory' )
        INNER JOIN sniffer_plugin_profiles sniffer ON ( op.profile_id = sniffer.id AND sniffer.enabled = true )
        INNER JOIN profiles ON ( sniffer.profile_id = profiles.id )",
      :conditions => "products.enterprise_id = #{profile.id} AND profiles.id <> #{profile.id}" }
    }

    Enterprise.has_many :input_categories, :through => :inputs, :source => :product_category, :uniq => true
    Enterprise.has_many :product_categories, :through => :products, :source => :product_category, :uniq => true

    #Rails fail :P 
    #Enterprise.has_many :needing_products, :through => :products, :source => :needing_products, :uniq => true
    #Product.has_many :needing_products, :through => :inputs, :source => :needing_products, :uniq => true
    #Input.has_many :needing_products, :through => :product_category, :source => :products, :uniq => true
    #ProductCategory.has_many :needing_products, :through => :inputs, :source => :needing_products, :uniq => true
    #
    #Enterprise.has_many :using_products, :through => :products, :source => :using_products, :uniq => true
    #Product.has_many :using_products, :through => :product_category, :source => :using_products, :uniq => true
    #ProductCategory.has_many :using_products, :through => :inputs, :source => :product, :uniq => true
  end

end
