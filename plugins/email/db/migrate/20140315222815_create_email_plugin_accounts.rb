class CreateEmailPluginAccounts < ActiveRecord::Migration
  def self.up
    create_table :email_plugin_accounts do |t|
      t.string :type
      t.integer :profile_id
      t.string :host
      t.integer :port
      t.string :username
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :email_plugin_accounts
  end
end
