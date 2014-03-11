class RemoveMessagesTable < ActiveRecord::Migration
  def self.up
    drop_table :received_messages
    drop_table :message_threads
    drop_table :messages
  end
end
