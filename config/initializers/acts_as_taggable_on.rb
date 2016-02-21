# see https://github.com/mbleigh/acts-as-taggable-on/issues/712
require 'acts_as_taggable_on/taggable/core'
ActsAsTaggableOn::Taggable::Core::ClassMethods.module_eval do
  def quote_value(value, column = nil)
    ActsAsTaggableOn::Utils.active_record5? ? super(value) : super(value, column)
  end
end

