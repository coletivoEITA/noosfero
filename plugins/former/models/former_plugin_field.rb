class FormerPluginField < ActiveRecord::Base
  belongs_to :form, :class_name => 'FormerPluginFormField', :foreign_key => :form_field_id
  has_many :values, :class_name => 'FormerPluginValue', :foreign_key => :field_id, :dependent => :destroy

  def form_method
    'former_plugin_field_' + self.id.to_s
  end
end
