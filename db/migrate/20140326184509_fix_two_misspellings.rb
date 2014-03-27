class FixTwoMisspellings < ActiveRecord::Migration
  def change
    rename_column :details, :vetinary_school, :veterinary_school
    rename_column :details, :vetinary_school_year, :veterinary_school_year
    rename_column :details, :licence_number, :license_number
    rename_column :details, :licence_state, :license_state
  end
end
