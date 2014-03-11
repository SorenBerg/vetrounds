class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.text :content
      t.integer :animal_type
      t.integer :animal_age
      t.integer :medication
      t.text :medication_detail
      t.integer :flea_preventives
      t.text :flea_preventives_detail
      t.integer :current_medical_conditions
      t.text :current_medical_conditions_detail
      t.integer :previous_medical_conditions
      t.text :previous_medical_conditions_detail
      t.text :feed_pet_detail
      t.boolean :answered, default: false

      t.timestamps
    end
  end
end
