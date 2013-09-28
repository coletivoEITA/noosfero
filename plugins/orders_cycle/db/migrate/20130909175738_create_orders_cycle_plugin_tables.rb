class CreateOrdersCyclePluginTables < ActiveRecord::Migration
  def self.up
    # check if distribution plugin already moved the table
    return if ActiveRecord::Base.connection.table_exists? "orders_cycle_plugin_cycles"

    create_table "orders_cycle_plugin_cycle_orders" do |t|
      t.integer  "cycle_id"
      t.integer  "order_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "orders_cycle_plugin_cycle_products" do |t|
      t.integer "cycle_id"
      t.integer "product_id"
    end

    create_table "orders_cycle_plugin_cycles" do |t|
      t.integer  "code"
      t.string   "name"
      t.text     "description"
      t.datetime "start"
      t.datetime "finish"
      t.string   "status"
      t.text     "opening_message"
      t.datetime "delivery_start"
      t.datetime "delivery_finish"
      t.decimal  "margin_percentage"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "orders_cycle_plugin_cycles", ["status"]
  end

  def self.down
    drop_table "orders_cycle_plugin_cycles"
    drop_table "orders_cycle_plugin_cycle_products"
    drop_table "orders_cycle_plugin_cycle_orders"
  end
end