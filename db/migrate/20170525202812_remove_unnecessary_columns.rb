class RemoveUnnecessaryColumns < ActiveRecord::Migration
  def change
    remove_column :users, :sw_username
    remove_column :users, :sw_password
  end
end
