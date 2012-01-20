module BoxesHelper

  def insert_boxes(content)
    if @controller.send(:boxes_editor?) && @controller.send(:uses_design_blocks?)
      content + display_boxes_editor(@controller.boxes_holder)
    else
      profile = @controller.boxes_holder.is_a?(Profile) ? @controller.boxes_folder : nil
      maybe_display_custom_element(@controller.boxes_holder, :custom_header_expanded, :id => 'profile-header') +
      if logged_in? and profile and profile.admins? current_user.person
        maybe_display_custom_element(@controller.boxes_holder, :edit_home_boxes, :id => 'profile-header')
      else
        ''
      end +
      if @controller.send(:uses_design_blocks?)
        display_boxes(@controller.boxes_holder, content)
      else
        content_tag('div',
          content_tag('div',
            content_tag('div', wrap_main_content(content), :class => 'no-boxes-inner-2'),
            :class => 'no-boxes-inner-1'
          ),
          :class => 'no-boxes'
        )
      end +
      maybe_display_custom_element(@controller.boxes_holder, :custom_footer_expanded, :id => 'profile-footer')
    end
  end

  def box_decorator
    @box_decorator || BlockPresenter.new(nil, self)
  end

  def with_box_decorator(dec, &block)
    @box_decorator = dec.new nil, self
    result = block.call
    @box_decorator = box_decorator

    result
  end

  def display_boxes_editor(holder)
    with_box_decorator BlockEditorPresenter do
      content_tag('div', display_boxes(holder, '&lt;' + _('Main content') + '&gt;'), :id => 'box-organizer')
    end
  end

  def display_boxes(holder, main_content)
    boxes = holder.boxes.first(holder.boxes_limit)
    content = boxes.reverse.map { |item| display_box(item, main_content) }.join("\n")
    content = main_content if (content.blank?)

    content_tag('div', content, :class => 'boxes', :id => 'boxes' )
  end

  def maybe_display_custom_element(holder, element, options = {})
    if holder.respond_to?(element)
      content_tag('div', holder.send(element), options)
    else
      ''
    end
  end

  def display_box(box, main_content)
    content_tag('div', content_tag('div', display_box_content(box, main_content), :class => 'blocks'), :class => "box box-#{box.position}", :id => "box-#{box.id}" )
  end

  def display_updated_box(box)
    with_box_decorator BlockEditorPresenter do
      display_box_content(box, '&lt;' + _('Main content') + '&gt;')
    end
  end

  def display_box_content(box, main_content)
    context = { :article => @page, :request_path => request.path, :locale => locale }
    box_decorator.select_blocks(box.blocks, context).map { |item| display_block(item, main_content) }.join("\n") + box_decorator.block_target(box)
  end

  def display_block(block, main_content = nil)
    render :file => 'shared/block', :locals => {:block => block, :main_content => main_content, :use_cache => use_cache? }
  end

  def use_cache?
    box_decorator.is_a?(BlockPresenter)
  end

  def display_block_content(block, main_content = nil)
    content = block.main? ? wrap_main_content(main_content) : block.content
    result = extract_block_content(content)
    footer_content = extract_block_content(block.footer)
    unless footer_content.blank?
      footer_content = content_tag('div', footer_content, :class => 'block-footer-content' )
    end

    options = {
      :class => classes = ['block', block_css_classes(block) ].uniq.join(' '),
      :id => "block-#{block.id}"
    }
    if ( block.respond_to? 'help' )
      options[:help] = block.help
    end
    unless block.visible?
      options[:title] = _("This block is invisible. Your visitors will not see it.")
    end
    @controller.send(:content_editor?) || @plugins.enabled_plugins.each do |plugin|
      result = plugin.parse_content(result)
    end
    box_decorator.block_target(block.box, block) +
      content_tag('div',
       content_tag('div',
         content_tag('div',
           result + footer_content + box_decorator.block_edit_buttons(block),
           :class => 'block-inner-2'),
         :class => 'block-inner-1'),
       options) +
    box_decorator.block_handle(block)
  end

  def wrap_main_content(content)
    (1..8).to_a.reverse.inject(content) { |acc,n| content_tag('div', acc, :id => 'main-content-wrapper-' + n.to_s) }
  end

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

  def current_blocks
    @controller.boxes_holder.boxes.map(&:blocks).inject([]){|ac, a| ac + a}
  end

  # DEPRECATED. Do not use this.
  def import_blocks_stylesheets(options = {})
    @blocks_css_files ||= current_blocks.map{|b|'blocks/' + block_css_class_name(b)}.uniq
    stylesheet_import(@blocks_css_files, options)
  end

  def block_css_class_name(block)
    block.class.name.underscore.gsub('_', '-')
  end
  def block_css_classes(block)
    classes = block_css_class_name(block)
    classes += ' invisible-block' if block.display == 'never'
    classes
  end

end
