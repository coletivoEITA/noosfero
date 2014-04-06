class OrdersCyclePlugin::CycleOrder < Noosfero::Plugin::ActiveRecord

  belongs_to :cycle, :class_name => 'OrdersCyclePlugin::Cycle'
  belongs_to :sale, :class_name => 'OrdersPlugin::Sale', :foreign_key => :order_id, :dependent => :destroy
  belongs_to :purchase, :class_name => 'OrdersPlugin::Purchase', :foreign_key => :order_id, :dependent => :destroy

  validates_presence_of :cycle
  validate :sale_or_purchase

  protected

  def sale_or_purchase
    errors.add :base, "Specify a sale of purchase" unless self.sale or self.purchase
  end

end
