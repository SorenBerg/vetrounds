class ChangeBioColumnType < ActiveRecord::Migration
  def change
  	change_column :users, :bio, :text
  end
end
