class FormerPluginOptionField < FormerPluginField
  has_many :options, :class_name => 'FormerPluginOption', :foreign_key => :field_id, :dependent => :destroy
end
