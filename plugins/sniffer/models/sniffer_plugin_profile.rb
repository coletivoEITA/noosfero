class SnifferPluginProfile < ActiveRecord::Base
  belongs_to :profile

  has_many :opportunities, :class_name => 'SnifferPluginOpportunity', :foreign_key => 'profile_id', :dependent => :destroy
  has_many :product_categories, :through => :opportunities, :foreign_key => 'profile_id', :source => :product_category,
    :conditions => ['opportunity_type = ?', 'ProductCategory']

  has_many :cat_needing_products, :through => :product_categories, :source => :needing_products, :uniq => true
  has_many :cat_using_products, :through => :product_categories, :source => :using_products, :uniq => true

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

  def needing_products
    if !profile.enterprise?
      cat_needing_products
    else
      (profile.needing_products + cat_needing_products).uniq
    end
  end

  def using_products
    if !profile.enterprise?
      cat_using_products
    else
      (profile.using_products + cat_needing_products).uniq
    end
  end

end
