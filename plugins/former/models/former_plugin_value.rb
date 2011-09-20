class FormerPluginValue < ActiveRecord::Base
  belongs_to :field, :class_name => 'FormerPluginField'
  belongs_to :option, :class_name => 'FormerPluginOption', :foreign_key => 'option_id'

  validates_presence_of :field

  alias_method :original_option, :option
  def option
    original_option || option_from_content || option_default
  end

  def option_with_content=(value)
    self.option_without_content = value
    option_to_content
  end
  alias_method_chain :option=, :content

  def option_to_content
    self.content = option ? option.name : nil
  end

  def option_from_content
    o = self.field.options.find_by_name self.content
    option = o if o
  end

  def option_default
    o = field.options.first
    option = o if o
  end

end
