class CreateAdminUser < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean, :default => false
    @user = User.new(name: "Admin User", email: "admin@vetrounds.com", password: "au2lopba", password_confirmation: "au2lopba", is_vet: false, enabled: true, is_admin: true)
    @user.save
  end
end
