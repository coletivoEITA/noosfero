class BlockPresenter < BasePresenter

  def block_target(box, block = nil)
    ''
  end

  def block_handle(block)
    ''
  end

  def block_edit_buttons(block)
    ''
  end

  def block_css_classes(block)
    classes = block_css_class_name(block)
    classes += ' invisible-block' if block.display == 'never'
    classes += " block-#{block.percentage_width}percent"
    classes
  end

end
