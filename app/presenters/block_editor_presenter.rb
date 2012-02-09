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
    # FIXME hardcoded
    return '' if box.position == 1

    id =
      if block.nil?
        "end-of-box-#{box.id}"
      else
        "before-block-#{block.id}"
      end

    content_tag('div', _('drop something here'), :id => id, :class => 'block-target' ) + drop_receiving_element(id, :url => { :action => 'move_block', :target => id }, :accept => 'block', :hoverclass => 'block-target-hover')
  end

  # makes the given block draggable so it can be moved away.
  def block_handle(block)
    # FIXME hardcoded
    return '' if block.box.position == 1

    draggable_element("block-#{block.id}", :revert => true)
  end

  def block_edit_buttons(block)
    buttons = []
    nowhere = 'javascript: return false;'

    if block.first?
      buttons << icon_button('up-disabled', _("Can't move up anymore."), nowhere)
    else
      buttons << icon_button('up', _('Move block up'), { :action => 'move_block_up', :id => block.id }, { :method => 'post' })
    end

    if block.last?
      buttons << icon_button('down-disabled', _("Can't move down anymore."), nowhere)
    else
      buttons << icon_button(:down, _('Move block down'), { :action => 'move_block_down' ,:id => block.id }, { :method => 'post'})
    end

    holder = block.owner
    # move to opposite side
    # FIXME too much hardcoded stuff
    if holder.layout_template == 'default'
      if block.box.position == 2 # area 2, left side => move to right side
        buttons << icon_button('right', _('Move to the opposite side'), { :action => 'move_block', :target => 'end-of-box-' + holder.boxes[2].id.to_s, :id => block.id }, :method => 'post' )
      elsif block.box.position == 3 # area 3, right side => move to left side
        buttons << icon_button('left', _('Move to the opposite side'), { :action => 'move_block', :target => 'end-of-box-' + holder.boxes[1].id.to_s, :id => block.id }, :method => 'post' )
      end
    end

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

  def select_blocks(arr, context)
    arr
  end

end
