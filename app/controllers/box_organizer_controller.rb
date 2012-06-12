class BoxOrganizerController < ApplicationController

  before_filter :login_required

  include BoxesHelper

  def index
  end

  def move_block
    @block = boxes_holder.blocks.find(params[:id].gsub(/^block-/, ''))
    @source_box = @block.box
    @target_box = boxes_holder.boxes.find(params[:box_id].gsub(/^box-/, ''))

    if @source_box != @target_box
      @block.remove_from_list
      @block.box = @target_box
    end
    @block.insert_at params[:position].to_i
    @block.save!
    @target_box.reload

    self.box_presenter = BlockEditorPresenter
    render :partial => 'boxes/show_block', :locals => {:block => @block, :main_content => false, :use_cache => false}
  end

  def add_block
    type = params[:type]
    if ! type.blank?
      if available_blocks.map(&:name).include?(type)
        @box = boxes_holder.boxes.find(params[:box_id])
        @box.blocks << type.constantize.new
        render :partial => 'shared/page_reload'
      else
        raise ArgumentError.new("Type %s is not allowed. Go away." % type)
      end
    else
      @block_types = available_blocks
      @boxes = boxes_holder.boxes
      render :action => 'add_block', :layout => false
    end
  end

  def edit
    @block = boxes_holder.blocks.find(params[:id])
    render :action => 'edit', :layout => false
  end

  def update
    @block = boxes_holder.blocks.find(params[:id])
    @block.update_attributes(params[:block])
    render :nothing => true
  end

  def save
    @block = boxes_holder.blocks.find(params[:id])
    @block.update_attributes(params[:block])
    render :partial => 'shared/page_reload'
  end

  def remove
    @block = Block.find(params[:id])
    session[:notice] = _('Failed to remove block') unless @block.destroy
  end

  protected

  def boxes_editor?
    true
  end

end
