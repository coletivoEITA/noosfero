module BoxesHelper

  def insert_boxes(content)
    editing = @controller.send(:boxes_editor?) && @controller.send(:uses_design_blocks?)

    #content_tag('div', display_boxes(holder, '&lt;' + _('Main content') + '&gt;'), :id => 'box-organizer')
    
    display_edit_bar(editing) + display_profile_header + display_content(content) + display_profile_footer
  end

  def display_profile_header
    maybe_display_custom_element(@controller.boxes_holder, :custom_header_expanded, :id => 'profile-header')
  end

  def display_edit_bar(editing = false)
    profile_admin = logged_in? and profile and profile.admins.include?(current_user.person)
    env_admin = @controller.is_a?(EnvironmentDesignController)

    if !environment.enabled?('cant_change_homepage') and (profile_admin or env_admin)
      self.box_presenter = BlockEditorPresenter
      render :partial => 'shared/boxes/edit_bar', :locals => {:editing => editing}
    else
      ''
    end
  end

  def display_content(content)
    if @controller.send(:uses_design_blocks?)
      display_boxes(@controller.boxes_holder, content)
    else
      content_tag('div',
        content_tag('div',
          content_tag('div', content, :class => 'no-boxes-inner-2'),
          :class => 'no-boxes-inner-1'
        ),
        :class => 'no-boxes'
      )
    end
  end

  def display_profile_footer
    maybe_display_custom_element(@controller.boxes_holder, :custom_footer_expanded, :id => 'profile-footer')
  end

  def display_boxes(holder, main_content)
    boxes = holder.boxes.first(holder.boxes_limit)
    content = boxes.reverse.map { |item| display_box(item, main_content) }.join("\n")
    content = main_content if (content.blank?)

    content_tag('div', content, :class => 'boxes', :id => 'boxes' )
  end

  def display_box(box, main_content)
    content_tag('div', content_tag('div', display_box_content(box, main_content), :class => 'blocks'),
                :class => "box box-#{box.position}", :id => "box-#{box.id}" )
  end

  def display_updated_box(box)
    with_box_presenter BlockEditorPresenter do
      display_box_content(box, '&lt;' + _('Main content') + '&gt;')
    end
  end

  def display_box_content(box, main_content)
    box.blocks.select{ |block| block.visible?(context) }.map{ |block| display_block(block, main_content) }.join("\n") +
      box_presenter.block_target(box) +
      content_tag('div', '', :style => 'clear: both')
  end

  def display_block(block, main_content = nil)
    render :file => 'shared/block', :locals => {:block => block, :main_content => main_content, :use_cache => use_cache? }
  end

  def display_block_content(block, main_content = nil)
    content = block.main? ? main_content : block.content
    result = extract_block_content(content)
    footer_content = extract_block_content(block.footer)
    unless footer_content.blank?
      footer_content = content_tag('div', footer_content, :class => 'block-footer-content' )
    end

    options = {
      :class => classes = ['block', box_presenter.block_css_classes(block) ].uniq.join(' '),
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
    box_presenter.block_target(block.box, block) +
      content_tag('div',
       content_tag('div',
         content_tag('div',
           result + footer_content + box_presenter.block_edit_buttons(block),
           :class => 'block-inner-2'),
         :class => 'block-inner-1'),
       options) +
    box_presenter.block_handle(block)
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

  private

  def profile
    @profile ||= @controller.boxes_holder.is_a?(Profile) ? @controller.boxes_folder : nil
  end
  
  def block_css_class_name(block)
    block.class.name.underscore.gsub('_', '-')
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

  def maybe_display_custom_element(holder, element, options = {})
    if holder.respond_to?(element)
      content_tag('div', holder.send(element), options)
    else
      ''
    end
  end

  # DEPRECATED. Do not use this.
  def import_blocks_stylesheets(options = {})
    @blocks_css_files ||= current_blocks.map{|b|'blocks/' + block_css_class_name(b)}.uniq
    stylesheet_import(@blocks_css_files, options)
  end
  def current_blocks
    @controller.boxes_holder.boxes.map(&:blocks).inject([]){|ac, a| ac + a}
  end

end
