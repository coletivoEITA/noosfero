module ActsAsHavingBoxes

  module ClassMethods

    def acts_as_having_boxes
      has_many :boxes, :as => :owner, :dependent => :destroy, :order => 'position'
      has_many :blocks, :through => :boxes, :source => :blocks
      include InstanceMethods
    end

  end

  module InstanceMethods

    # returns 3 unless the class table has a boxes_limit column. In that case
    # return the value of the column. 
    def boxes_limit
      LayoutTemplate.find(layout_template).number_of_boxes || 3
    end

  end

end

ActiveRecord::Base.extend ActsAsHavingBoxes::ClassMethods
