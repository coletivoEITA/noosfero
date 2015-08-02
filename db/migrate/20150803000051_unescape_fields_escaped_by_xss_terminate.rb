class UnescapeFieldsEscapedByXssTerminate < ActiveRecord::Migration

  def up
    unescape_model AbuseReport, :reason
    unescape_model CreateEnterprise, :acronym, :address, :contact_person, :contact_phone, :economic_activity, :legal_form, :management_information, :name
    unescape_model Comment, :body, :title, :name
    unescape_model Community, :name, :address, :contact_phone, :description
    unescape_model Event, :name, :body, :address
    unescape_model Environment, :message_for_disabled_enterprise
    unescape_model Folder, :name, :body
    unescape_model Mailing, :subject, :body
    unescape_model Organization, :acronym, :contact_person, :contact_email, :legal_form, :economic_activity, :management_information
    unescape_model Product, :name, :description
    unescape_model ValidationInfo, :validation_methodology, :restrictions
    unescape_model TinyMceArticle, :name, :abstract, :body

    # STI base classes
    unescape_model Article, :name
    unescape_model Profile, :name, :nickname, :address, :contact_phone, :description, :custom_footer, :custom_header
  end

  def unescape_model klass, *fields
    puts "Unescaping #{klass} fields: #{fields}"
    serialized_fields = fields - klass.column_names.map(&:to_sym)
    fields -= serialized_fields
    count = 0

    klass.find_each(batch_size: 50) do |m|
      begin
        attributes = fields.inject [] do |attrs, f|
          next attrs if (v = m[f]).blank? or (unev = CGI.unescapeHTML v) == v
          attrs << [f, unev]
        end
        attributes = Hash[attributes]

        if serialized_fields.present?
          sattributes = serialized_fields.inject [] do |attrs, f|
            next attrs if (v = m.send(f)).blank? or (unev = CGI.unescapeHTML v) == v
            attrs << [f, unev]
          end
          sattributes = Hash[sattributes]

          if sattributes.present?
            value = m.settings_field
            value.merge! sattributes
            attributes[m.class.settings_field] = value
          end
        end

        if attributes.present?
          m.update_columns attributes
          count += 1
        end
      rescue
        puts "Failing for: #{m.inspect}"
        raise
      end
    end

    puts "Updated #{count} records"
  end

end
