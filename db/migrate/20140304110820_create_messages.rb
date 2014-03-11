class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :thread_id
      t.integer :sender_id
      t.boolean :sender_deleted, :default => false
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
