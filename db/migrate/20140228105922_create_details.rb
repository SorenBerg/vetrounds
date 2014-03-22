class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :user_id
      t.string :zipcode
      t.string :area_of_practice
      t.string :vetinary_school
      t.string :vetinary_school_year
      t.string :degree
      t.string :licence_number
      t.string :licence_state

      t.timestamps
    end
  end
end
