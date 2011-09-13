class SnifferPluginOpportunity < ActiveRecord::Base
  belongs_to :sniffer_profile, :class_name => 'SnifferPluginProfile', :foreign_key => 'profile_id'

  belongs_to :opportunity, :polymorphic => true
  belongs_to :product_category, :class_name => 'ProductCategory', :foreign_key => 'opportunity_id',
    :conditions => ['opportunity_type = ?', 'ProductCategory']
end
