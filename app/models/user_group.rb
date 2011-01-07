class UserGroup < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
	
	after_save :update_easy_groups
	after_destroy :update_easy_groups
	
	def update_easy_groups
		self.user.update_easy_groups
	end
end
