class CreateMessagingPluginMessages < ActiveRecord::Migration
  def self.connection
    MessagingPlugin::Message.connection
  end

  def self.up
    create_table :messaging_plugin_messages do |t|
      t.string :type
      t.text :identifier

      t.text :from
      t.text :to
      t.text :cc
      t.text :bcc

      t.datetime :date
      t.text :subject
      t.text :body
      t.text :content_type

      t.text :in_reply_to

      t.text :data, :default => "--- {}\n\n"

      t.timestamps
    end
  end

  def self.down
    drop_table :messaging_plugin_messages
  end
end
