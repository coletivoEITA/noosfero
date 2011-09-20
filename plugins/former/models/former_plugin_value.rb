class FormerPluginValue < ActiveRecord::Base
  belongs_to :field, :class_name => 'FormerPluginField'
  belongs_to :option, :class_name => 'FormerPluginOption', :foreign_key => 'option_id'

  validates_presence_of :field

  before_save :option_to_value

  def option
    (FormerPluginOption.find(option_id) || field.options.first) if option_id
  end

  def option_from_value
    option ||= self.field.options.find_by_name(self.content)
  end

  def option_to_value
    self.content = option.name if option
  end
end
