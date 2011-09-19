module FormerPlugin::FieldHelper
  include ApplicationHelper

  def widgets_for_form(form, identifier, options = {}, html_options = {})
    identifier = identifier.to_s

    FormerPluginFormField.by_identifier(identifier).collect(&:fields).flatten.map do |field| 
      field_widget(form, field, options, html_options)
    end.join('\n')
  end

  def field_widget(form, field, options = {}, html_options = {})
    ret = case field.class.name
    when 'FormerPluginOptionField'
      f = NoosferoFormBuilder::output_field( field.name,collection_select(form.object_name, field.form_method, field.options, 'id', 'name'));
      f = required(f) if field.required 
      f
    when 'FormerPluginField'
      labelled_form_field(field.name, text_field(form.object_name, field.form_method)) 
    end

    if options[:required]
      ret = required ret
    end 

    ret
  end

end
