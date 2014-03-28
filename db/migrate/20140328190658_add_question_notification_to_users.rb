class AddQuestionNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :question_notification, :string, :default => "none"
  end
end
