class Box < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true
  acts_as_list :scope => 'owner_id = #{owner_id} and owner_type = \'#{owner_type}\''

  has_many :blocks, :dependent => :destroy, :order => 'position'

  def main?
    position == 1
  end

  def main=(value)
    position = value == true ? 1 : -1
  end

  named_scope :main, :conditions => {:position => 1}

end
