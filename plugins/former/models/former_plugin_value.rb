class FormerPluginValue < ActiveRecord::Base
  belongs_to :field, :class_name => 'FormerPluginField'
  belongs_to :option, :class_name => 'FormerPluginOption', :foreign_key => 'option_id'

  validates_presence_of :field

  def option_from_value
    option ||= self.field.options.find_by_name(self.value)
  end

  before_save :option_to_value

  protected 

  def option_to_value
    self.value = option.name if option
  end
end
