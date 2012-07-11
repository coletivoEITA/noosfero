module BoxesHelper

  def extract_block_content(content)
    case content
    when Hash
      content_tag('iframe', '', :src => url_for(content))
    when String
      if content.split("\n").size == 1 and content =~ /^https?:\/\//
        content_tag('iframe', '', :src => content)
      else
        content
      end
    when Proc
      self.instance_eval(&content)
    when NilClass
      ''
    else
      raise "Unsupported content for block (#{content.class})"
    end
  end

  def block_css_class_name(block)
    block.class.name.underscore.gsub('_', '-').gsub('/', '-')
  end

  def box_presenter
    @box_presenter ||= BlockPresenter.new nil, self
  end
  def box_presenter=(value)
    @box_presenter = value.new nil, self
  end

  def use_cache?
    box_presenter.is_a?(BlockPresenter)
  end

end
