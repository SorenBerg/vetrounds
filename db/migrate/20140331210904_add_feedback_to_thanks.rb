class AddFeedbackToThanks < ActiveRecord::Migration
  def change
    add_column :thanks, :feedback, :text
  end
end
