class FormerPluginFormField < ActiveRecord::Base
  has_many :fields, :class_name => 'FormerPluginField', :foreign_key => :form_field_id, :dependent => :destroy

  named_scope :by_identifier, lambda { |identifier| { :conditions => {:identifier => identifier} } }

  validates_presence_of :identifier
end
