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
    def method_missing(method, *args, &block)
      if method.to_s.starts_with? 'former_plugin_field_'
        id = method.to_s.gsub(/^former_plugin_field_(\d{1,})=?/, '\1')
        field = FormerPluginField.find(id)
        value = field.values.find_by_instance_id(self.id)
        if value.nil?
          value = FormerPluginValue.create!(:field => field, :instance_id => self.id)
        end
        
        if method.to_s.ends_with? '='
          case field.class.name
          when 'FormerPluginOptionField'
            value.option = FormerPluginOption.find(*args.first.to_i)
          else
            value.value = *args
          end
          value.save!
        else
          case field.class.name
          when 'FormerPluginOptionField'
            o = value.option_from_value
            o ? value.option_from_value.id : nil
          else
            value.value
          end

        end
      else
        super
      end
    end
  end

  module ClassMethods
  end

  module HasFormMethods
    def has_form(identifier, options = {})
      f = FormerPluginFormField.find_by_identifier(identifier.to_s)
      attr = {:identifier => identifier.to_s, :name => options[:name], :entity_type => name}
      if f.nil?
        f = FormerPluginFormField.create!(attr)
      else
        f.attributes = attr
        f.save!
      end
  
      extend ClassMethods
      include InstanceMethods
    end
  end

end

ActiveRecord::Base.extend FormerPluginMethods::HasFormMethods

Rails.configuration.to_prepare do
  if FormerPluginFormField.table_exists?
    Enterprise.has_form :bsc_fields, :name => _('BSC form')
    Article.has_form :buyer_fields, :name => _('Buyer form')
    Article.has_form :learning_fields, :name => _('Learning form')
    Article.has_form :contract_fields, :name => _('Contract form')
    Article.has_form :feedback_fields, :name => _('Feedback form')
  end
end
