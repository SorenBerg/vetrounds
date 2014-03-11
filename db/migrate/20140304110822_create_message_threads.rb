class CreateMessageThreads < ActiveRecord::Migration
  def self.up
    create_table :message_threads do |t|
      t.string :subject
      t.timestamps
    end
  end

  def self.down
    drop_table :message_threads
  end
end
