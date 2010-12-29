class AddEncryptionSaltToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_salt, :string
    add_column :users, :crypted_password, :string
    remove_column :users, :password
  end

  def self.down
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    add_column :users, :password, :string
  end
end
