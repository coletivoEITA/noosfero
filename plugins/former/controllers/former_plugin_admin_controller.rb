class FormerPluginAdminController < AdminController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')
 
  protect 'edit_environment_features', :environment

  helper FormerPlugin::FieldEditHelper

  def index
    
  end

  def remove
    id = params[:id]
    type  = params[:type]
    
    begin
      if type == 'field_option'
        status_msg = _('Option was deleted')
        FormerPluginOption.find_by_id(id).destroy
      else
        status_msg = _('Field was deleted')
        FormerPluginOptionField.find_by_id(id).destroy
      end
    rescue
      if type == 'field_option'
        status_msg = _('Option can not be deleted')
      else
        status_msg = _('Field can not be deleted')
      end
    end
    
    render :json => {:status_msg => status_msg}
  end

  def add_new_field
    form_identifier = params[:form_identifier]
    field_id = nil
    status_msg = _('Field was created')
    begin
      form = FormerPluginFormField.find_by_identifier(form_identifier)
      if form.nil?
        raise 'Can not be found form'
      end
      field = FormerPluginOptionField.create!(:form => form)
      field_id = field.id
    rescue
      status_msg = _('Field can not be created')
    end

    render :json => {:field_id => field_id, :status_msg => status_msg}
  end

  def add_new_option
    field_id = params[:field_id]
    status_msg = _('Option was created')
    option_id = nil
    begin
      form_field = FormerPluginOptionField.find_by_id(field_id)
      if form_field.nil?
        raise _('Can not be found form_field')
      end
      option = form_field.options.create!(:name => '');
      option_id = option.id
    rescue 
      status_msg = _('Option can not be created')
    end

    render :json => {:option_id => option_id, :status_msg => status_msg}
  end

  def save_field

    forms = params[:forms]
    status_msg = _('Field saved')
    success = true
    begin
      
      forms.sort.each do |form_identifier, fv|
        form = FormerPluginFormField.find_by_identifier(form_identifier)
        if !form.nil?
          fv[:fields].sort.map do |field_id, value|
            f = FormerPluginOptionField.find_by_id(field_id)
            f.name = value[:name]
            f.required = value[:required]
            f.save!
            options = value[:options]
            unless options == nil
              options.sort.map do |option, option_value|
                foption = FormerPluginOption.find_by_id(option)
                foption.name = option_value
                foption.save!
              end
            end
          end
        end
      end
      
    rescue 
      status_msg =  _('Fields could not be saved')
      success = false
    end
    
    render :json => {:success => success, :status_msg => status_msg}

  end
end
