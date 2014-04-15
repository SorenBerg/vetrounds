class AddTagToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tag, :integer, :default => 0
  end
end
