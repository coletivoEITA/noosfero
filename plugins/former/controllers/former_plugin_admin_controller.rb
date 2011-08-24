class FormerPluginAdminController < AdminController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  #no_design_blocks
  
  protect 'edit_environment_features', :environment

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

    status_msg = _('Field was created')
    begin
      form = FormerPluginFormField.find_by_identifier(form_identifier)
      field = FormerPluginOptionField.create!(:form => form)
    rescue
      status_msg = _('Field can not be created')
    end

    render :json => {:field_id => field.id, :status_msg => status_msg}

  end

  def add_new_option

    field_id = params[:field_id]
    status_msg = _('Option was created')
    begin
      form_field = FormerPluginOptionField.find_by_id(field_id)
      option = form_field.options.create!(:name => '');
    rescue Exception => ex
      status_msg = _('Option can not be created')
    end
    render :json => {:option_id => option.id, :status_msg => status_msg}

  end

  def save
    forms = params[:forms]

    if(forms == nil)
      return false
    end

    forms.sort.each do |form_identifier, fv|
        form = FormerPluginFormField.find_by_identifier(form_identifier)
        fields = if !form.nil?
          fv[:fields].sort.map do |field_id, value|
            f = FormerPluginOptionField.find_by_id(field_id)
            f.name = value[:name]
            f.required = value[:required]
            options = value[:options]
            unless options == nil
              options.sort.map do |option, option_value|
                foption = FormerPluginOption.find_by_id(option)
                foption.name = option_value
                foption.save!
              end
            end
            f.save!
            f
          end
        end
     end
  end

  def save_option
    
    save   
    render :text => _('Fields were saved.')

  end
end
