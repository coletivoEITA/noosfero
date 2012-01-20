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

  def select_blocks(arr, context)
    arr.select { |block| block.visible?(context) }
  end

end
