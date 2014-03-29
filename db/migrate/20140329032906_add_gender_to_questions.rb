class AddGenderToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :gender, :integer, :default => 0
  end
end