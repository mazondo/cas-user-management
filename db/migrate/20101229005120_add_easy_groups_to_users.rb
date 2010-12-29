class AddEasyGroupsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :easy_groups, :string
  end

  def self.down
    remove_column :users, :easy_groups
  end
end
