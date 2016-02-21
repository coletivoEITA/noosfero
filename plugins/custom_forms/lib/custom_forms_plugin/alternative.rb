class CustomFormsPlugin::Alternative < ApplicationRecord
  self.table_name = :custom_forms_plugin_alternatives

  validates_presence_of :label

  belongs_to :field, :class_name => 'CustomFormsPlugin::Field'

end

