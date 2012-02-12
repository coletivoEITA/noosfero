class BlockEditorPresenter < BlockPresenter

  # generates a place where you can drop a block and get the block moved to
  # there.
  #
  # If +block+ is not nil, then it means "place the dropped block before this
  # one.". Otherwise, it means "place the dropped block at the end of the
  # list"
  #
  # +box+ is always needed
  def block_target(box, block = nil)
    ''
  end

  # makes the given block draggable so it can be moved away.
  def block_handle(block)
    ''
  end

  def block_edit_buttons(block)
    buttons = []

    if block.editable?
      buttons << lightbox_icon_button(:edit, _('Edit'), { :action => 'edit', :id => block.id })
    end

    if !block.main?
      buttons << icon_button(:delete, _('Remove block'), { :action => 'remove', :id => block.id }, { :method => 'post', :confirm => _('Are you sure you want to remove this block?')})
    end

    if block.respond_to?(:help)
      buttons << thickbox_inline_popup_icon(:help, _('Help on this block'), {}, "help-on-box-#{block.id}") << content_tag('div', content_tag('h2', _('Help')) + content_tag('div', block.help, :style => 'margin-bottom: 1em;') + thickbox_close_button(_('Close')), :style => 'display: none;', :id => "help-on-box-#{block.id}")
    end

    if block.box.main? and block.editable?
      buttons << select_tag('block[percentage_width]', options_for_select(Block::PERCENTAGE_WIDTHS.map{ |p| [_("%d%") % p, p] }, block.percentage_width),
                            :onchange => "b = jQuery(this).parents('.block'); b[0].className = b[0].className.replace(/block-\\d*percent/g, '');" +
                              "b.addClass('block-'+this.value+'percent');" +
                              "jQuery.post('#{url_for(:controller => @controller.boxes_controller, :action => :update, :id => block.id)}', this.serialize());",
                            :onkeyup => "this.onchange()" )
    end

    content_tag('div', buttons.join("\n") + tag('br', :style => 'clear: left'), :class => 'block-edit-buttons button-bar')
  end

end
