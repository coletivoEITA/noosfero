class CustomFieldValue < ApplicationRecord

  belongs_to :custom_field
  belongs_to :customized, :polymorphic => true

  validate :can_save?

  def can_save?
    if value.blank? && custom_field.required
      errors.add(custom_field.name, _("can't be blank"))
      return false
    end
    return true
  end
end
