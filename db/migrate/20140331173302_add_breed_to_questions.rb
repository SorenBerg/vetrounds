class AddBreedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :breed, :integer, :default => 0
    add_column :questions, :breed_detail, :string
  end
end
