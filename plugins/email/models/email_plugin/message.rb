class EmailPlugin::Message < MessagingPlugin::Message

  set_table_name :messaging_plugin_messages

  validates_presence_of :date

  before_create :convert_to_html

  def convert_to_html
    return unless self.content_type != 'text/html'
    self.body = Text2HTML.convert self.body
  end

  protected

  class Text2HTML
    def self.convert text
      text = simple_format text
      text = auto_link text, :all, :target => '_blank'
      text = NonHTMLEscaper.sanitize text
      text
    end

    # based on http://www.ruby-forum.com/topic/87492
    def self.wbr_split str, len = 10
      fragment = /.{#{len}}/
        str.split(/(\s+)/).map! { |word|
        (/\s/ === word) ? word : word.gsub(fragment, '\0<wbr />')
      }.join
    end

    protected

    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TextHelper
    extend ActionView::Helpers::UrlHelper

    class NonHTMLEscaper < HTML::WhiteListSanitizer

      self.allowed_tags << 'wbr'

      def self.sanitize *args
        self.new.sanitize *args
      end

      protected

      # Copy, just to reference this Node definition
      def tokenize(text, options)
        options[:parent] = []
        options[:attributes] ||= allowed_attributes
        options[:tags]       ||= allowed_tags

        tokenizer = HTML::Tokenizer.new(text)
        result = []
        while token = tokenizer.next
          node = Node.parse(nil, 0, 0, token, false)
          process_node node, result, options
        end
        result
      end

      # gsub <> instead of returning nil
      def process_node(node, result, options)
        result << case node
        when HTML::Tag
          if node.closing == :close
            options[:parent].shift
          else
            options[:parent].unshift node.name
          end

          process_attributes_for node, options

          options[:tags].include?(node.name) ? node : node.to_s.gsub(/</, "&lt;").gsub(/>/, "&gt;")
        else
          bad_tags.include?(options[:parent].first) ? nil : node.to_s
        end
      end

      class Text < HTML::Text
        def initialize(parent, line, pos, content)
          super parent, line, pos, content
          @content = Text2HTML.wbr_split content
        end
      end

      # remove tag/attributes downcases and reference this Text
      class Node < HTML::Node
        def self.parse parent, line, pos, content, strict=true
          if content !~ /^<\S/
            Text.new(parent, line, pos, content)
          else
            scanner = StringScanner.new(content)

            unless scanner.skip(/</)
              if strict
                raise "expected <"
              else
                return Text.new(parent, line, pos, content)
              end
            end

            if scanner.skip(/!\[CDATA\[/)
              unless scanner.skip_until(/\]\]>/)
                if strict
                  raise "expected ]]> (got #{scanner.rest.inspect} for #{content})"
                else
                  scanner.skip_until(/\Z/)
                end
              end

              return HTML::CDATA.new(parent, line, pos, scanner.pre_match.gsub(/<!\[CDATA\[/, ''))
            end

            closing = ( scanner.scan(/\//) ? :close : nil )
            return Text.new(parent, line, pos, content) unless name = scanner.scan(/[^\s!>\/]+/)

            unless closing
              scanner.skip(/\s*/)
              attributes = {}
              while attr = scanner.scan(/[-\w:]+/)
                value = true
                if scanner.scan(/\s*=\s*/)
                  if delim = scanner.scan(/['"]/)
                    value = ""
                    while text = scanner.scan(/[^#{delim}\\]+|./)
                      case text
                      when "\\" then
                        value << text
                        value << scanner.getch
                      when delim
                        break
                      else value << text
                      end
                    end
                  else
                    value = scanner.scan(/[^\s>\/]+/)
                  end
                end
                attributes[attr] = value
                scanner.skip(/\s*/)
              end

              closing = ( scanner.scan(/\//) ? :self : nil )
            end

            unless scanner.scan(/\s*>/)
              if strict
                raise "expected > (got #{scanner.rest.inspect} for #{content}, #{attributes.inspect})"
              else
                # throw away all text until we find what we're looking for
                scanner.skip_until(/>/) or scanner.terminate
              end
            end

            HTML::Tag.new(parent, line, pos, name, attributes, closing)
          end
        end
      end
    end
  end

end
