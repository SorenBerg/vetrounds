class AddSignalmentToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :signalment, :integer, :default => 0
  end
end
