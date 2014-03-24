class FixColMisspell < ActiveRecord::Migration
  def change
  	rename_column :details, :area_of_practise, :area_of_practice
  end
end
