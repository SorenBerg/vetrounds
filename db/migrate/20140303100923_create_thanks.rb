class CreateThanks < ActiveRecord::Migration
  def change
    create_table :thanks do |t|
      t.integer :question_id
      t.integer :answer_id
      t.integer :from_id
      t.integer :to_id

      t.timestamps
    end
  end
end
