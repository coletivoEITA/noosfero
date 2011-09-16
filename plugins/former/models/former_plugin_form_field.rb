class FormerPluginFormField < ActiveRecord::Base
  has_many :fields, :class_name => 'FormerPluginField', :foreign_key => :form_field_id, :dependent => :destroy

  named_scope :by_identifier, lambda { |identifier| { :conditions => {:identifier => identifier} } }

  validates_presence_of :identifier

  acts_as_having_settings :field => :settings

  def self.find_or_create(identifier, entity_type, options = {})
    f = find_by_identifier identifier.to_s 
    attrs = {:identifier => identifier.to_s, :entity_type => entity_type}.merge options
    if f.nil?
      f = create! attrs 
    else
      f.update_attributes attrs
    end
    f
  end

end
