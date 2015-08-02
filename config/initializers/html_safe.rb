GettextI18nRails.translations_are_html_safe = true

class Array

  # object based copy of http://apidock.com/rails/ActionView/Helpers/OutputSafetyHelper/safe_join
  def safe_join sep=nil
    sep = ERB::Util.unwrapped_html_escape sep

    self.flatten.map!{ |i| ERB::Util.unwrapped_html_escape i }.join(sep).html_safe
  end

end

ActiveSupport::JSON::Encoding.escape_html_entities_in_json = true
# http://stackoverflow.com/a/31774454/670229
# just use .to_json instead of .to_json.html_safe
ActiveSupport::JSON.class_eval do
  class << self
    def encode_with_html_safe *args
      self.encode_without_html_safe(*args).html_safe
    end
    alias_method_chain :encode, :html_safe
  end
end

