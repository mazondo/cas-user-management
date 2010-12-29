class Group < ActiveRecord::Base
	has_many :user_groups, :dependent => :destroy
	belongs_to :user_group
	has_many :users, :through => :user_groups
	
	after_update :update_all_easy_groups
	after_destroy :update_all_easy_groups
	
	def update_all_easy_groups
		User.update_all_easy_groups
	end
end
