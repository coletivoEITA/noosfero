class SnifferPluginProfile < ActiveRecord::Base
  belongs_to :profile

  has_many :opportunities, :class_name => 'SnifferPluginOpportunity', :foreign_key => 'profile_id', :dependent => :destroy
  has_many :product_categories, :through => :opportunities, :source => :product_category, :foreign_key => 'profile_id', :class_name => 'ProductCategory',
    :conditions => ['sniffer_plugin_opportunities.opportunity_type = ?', 'ProductCategory']

  validates_presence_of :profile

  attr_accessible :product_category_string_ids
  def product_category_string_ids
    ''
  end
  def product_category_string_ids=(ids)
    ids = ids.split(',')
    self.product_categories = []
    r = ProductCategory.find(ids)
    self.product_categories = ids.collect {|id| r.detect {|x| x.id == id.to_i}}
    self.opportunities.find(:all, :conditions => {:opportunity_id => ids}).each{|o| o.opportunity_type = 'ProductCategory'; o.save! }
  end

  def profile_input_categories
    profile.input_categories
  end

  def profile_product_categories
    profile.product_categories
  end

  def all_categories
    (profile_product_categories + profile_input_categories + product_categories).uniq
  end

  def suppliers_products
    interests = Product.interests_suppliers_products(profile)
    return interests if !profile.enterprise?
    (Product.suppliers_products(profile) + interests).uniq
  end

  def buyers_products
    interests = Product.interests_buyers_products(profile)
    return interests if !profile.enterprise?
    (Product.buyers_products(profile) + interests).uniq
  end

end
