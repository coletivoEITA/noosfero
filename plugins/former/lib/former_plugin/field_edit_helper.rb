module FormerPlugin::FieldEditHelper
  include ApplicationHelper

  def field_edit_intl_messages
    label_names = [
      _("Add option"), _("Remove"), _("Save changes"),
      _("Field title"), _("Field options"),
      _("Are you sure you want to delete this option?"),
      _("Are you sure you want to delete this field?"),
      _("Required"), _("Options empty")
    ]
    javascript_tag "var label_names = #{label_names.to_json}"
  end

  def field_edit_widget(parent_id, form_field, field, options = {})
    field_json = {'id' => field.id, 'name' => field.name, 'options' => field.options.collect{ |o| [o.id,o.name] }, 'required' => field.required}.to_json
    javascript_tag "field_add('#{parent_id}', '#{form_field.identifier}', #{field_json}, #{options.to_json});"
  end

  def field_edit_new_script(parent_id, form_field, options = {})
    field_json = {'id' => 'new', 'name' => '', 'options' => [], 'required' => false}.to_json
    "field_add('#{parent_id}', '#{form_field.identifier}', #{field_json}, #{options.to_json});"
  end

end
