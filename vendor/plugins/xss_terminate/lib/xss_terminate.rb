module XssTerminate

  def self.sanitize_by_default=(value)
    @@sanitize_by_default = value
  end

  def self.included(base)
    base.extend(ClassMethods)
    # sets up default of stripping tags for all fields
    # FIXME read value from environment.rb
    @@sanitize_by_default = false
    base.send(:xss_terminate) if @@sanitize_by_default
  end

  module ClassMethods

    def xss_terminate(options = {})
      options[:with] ||= 'full'
      filter_with = 'sanitize_fields_with_' + options[:with]
      # :on is util when before_filter dont work for model
      case options[:on]
        when 'create'
          before_create filter_with
        when 'validation'
          before_validation filter_with
        else
          before_save filter_with
      end
      class_attribute "xss_terminate_#{options[:with]}_options".to_sym
      self.send("xss_terminate_#{options[:with]}_options=".to_sym, {
        :except => (options[:except] || []),
        :only => (options[:only] || options[:sanitize] || [])
      })
      include XssTerminate::InstanceMethods
    end

  end

  module InstanceMethods

    def sanitize_allowed_attributes
      ALLOWED_CORE_ATTRIBUTES | ALLOWED_CUSTOM_ATTRIBUTES
    end

    def sanitize_field sanitizer, field
      field = field.to_sym
      if self[field]
        self[field] = sanitizer.sanitize(self[field], scrubber: Rails::Html::PermitScrubber.new, encode_special_chars: false, attributes: sanitize_allowed_attributes)
      else
        value = self.send("#{field}")
        return unless value
        value = sanitizer.sanitize(value, scrubber: Rails::Html::PermitScrubber.new, encode_special_chars: false, attributes: sanitize_allowed_attributes)
        self.send("#{field}=", value)
      end
    end

    def  permit_scrubber
        scrubber = Rails::Html::PermitScrubber.new
        scrubber.tags = Rails.application.config.action_view.sanitized_allowed_tags
        scrubber.attributes = Rails.application.config.action_view.sanitized_allowed_attributes
        scrubber
    end

    def sanitize_columns(with = :full)
      only = eval "xss_terminate_#{with}_options[:only]"
      except = eval "xss_terminate_#{with}_options[:except]"
      unless except.empty?
        only.delete_if{ |i| except.include?( i.to_sym ) }
      end
      return only
    end

    def sanitize_fields_with_full
      sanitizer = Rails::Html::FullSanitizer.new
      columns = sanitize_columns :full
      columns.each do |column|
        sanitize_field sanitizer, column.to_sym
      end
    end

    def sanitize_fields_with_white_list
      sanitizer = Rails::Html::WhiteListSanitizer.new
      columns = sanitize_columns :white_list
      columns.each do |column|
        sanitize_field sanitizer, column.to_sym
      end
   end

    def sanitize_fields_with_html5lib
      sanitizer = HTML5libSanitize.new
      columns = sanitize_columns(:html5lib)
      columns.each do |column|
        sanitize_field sanitizer, column.to_sym
      end
    end

  end

end
