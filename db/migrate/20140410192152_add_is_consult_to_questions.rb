class AddIsConsultToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_consult, :boolean, :default => false
  end
end
