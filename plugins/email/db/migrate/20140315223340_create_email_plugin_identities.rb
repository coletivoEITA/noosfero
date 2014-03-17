class CreateEmailPluginIdentities < ActiveRecord::Migration
  def self.up
    create_table :email_plugin_identities do |t|
      t.integer :profile_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :email_plugin_identities
  end
end
