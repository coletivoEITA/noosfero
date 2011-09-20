class FormerPlugin < Noosfero::Plugin

  def self.plugin_name
    "Former"
  end

  def self.plugin_description
    _("Build form fields easily")
  end

  def admin_panel_links
    {:body => _('Manage form fields'), :url => {:controller => 'former_plugin_admin'}}
  end

  def control_panel_buttons
  end

  def stylesheet?
    true
  end

  def js_files
    language = FastGettext.locale
    [ 'former.js' ]
  end

end

module FormerPluginMethods
  module InstanceMethods
    def __former_plugin_value_set(field, args)
      value = field.values.find_by_instance_id(self.id) || FormerPluginValue.new(:field => field) 

      case field.class.name
      when 'FormerPluginOptionField'
        value.option = FormerPluginOption.find(args.to_i)
        value.option_to_value
        @former_plugin_values << value
        value.option.id
      else
        value.content = args
        @former_plugin_values << value
        value.content
      end
    end

    def __former_plugin_value_get(field)
      value = @former_plugin_values.select{ |v| v.field_id == field.id }.first
      value ||= field.values.find_by_instance_id(self.id) || FormerPluginValue.new(:field => field) 

      case field.class.name
      when 'FormerPluginOptionField'
        o = value.option_from_value
        o ? value.option.id : nil
      else
        value.content
      end
    end

    def method_missing(method, *args, &block)
      @former_plugin_values ||= []
      form = self.class.former_plugin_form
      field = form.nil? ? nil : form.fields.find_by_identifier(method.to_s.gsub(/(.+)=/, '\1'))
      if field
        if method.to_s.ends_with? '='
          __former_plugin_value_set(field, *args)
        else
          __former_plugin_value_get(field)
        end
      elsif method.to_s.starts_with? 'former_plugin_field_'
        id = method.to_s.gsub(/^former_plugin_field_(\d{1,})=?/, '\1')
        field = FormerPluginField.find(id)
        
        if method.to_s.ends_with? '='
          __former_plugin_value_set(field, *args)
        else
          __former_plugin_value_get(field, *args)
        end
      else
        super
      end
    end

    def former_plugin_save_values
      @former_plugin_values ||= []
      @former_plugin_values.each { |v| v.instance_id = self.id; v.save! }
      @former_plugin_values = []
    end

    def former_plugin_values
      self.class.former_plugin_form.values.find_by_instance_id self.id
    end
  end

  module ClassMethods
    def former_plugin_form
      FormerPluginFormField.find_or_create former_plugin_form_identifier, name, former_plugin_form_options
    end

    def former_plugin_fields
      former_plugin_form.fields
    end
  end

  module HasFormMethods
    def has_form(identifier, options = {})
      FormerPluginFormField.find_or_create identifier, name, options

      cattr_accessor :former_plugin_form_identifier
      cattr_accessor :former_plugin_form_options

      self.former_plugin_form_identifier = identifier
      self.former_plugin_form_options = options

      after_save :former_plugin_save_values
  
      extend ClassMethods
      include InstanceMethods
    end
  end

end

ActiveRecord::Base.extend FormerPluginMethods::HasFormMethods

if FormerPluginFormField.table_exists?
  Enterprise.has_form :bsc_fields, :name => _('BSC form')
  Article.has_form :buyer_fields, :name => _('Buyer form')
  Article.has_form :learning_fields, :name => _('Learning form')
  Article.has_form :contract_fields, :name => _('Contract form')
end
