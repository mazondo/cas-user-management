class User < ActiveRecord::Base
	#using authlogic to secure passwords
	acts_as_authentic do |c|
		c.maintain_sessions = false
      #c.my_config_option = my_value
    end # the configuration block is optional
    
	has_many :user_groups, :dependent => :destroy
	belongs_to :user_group
	has_many :groups, :through => :user_groups
	
	
	#when we update groups a user belongs to or update a group's name, we need to go through and regenerate all the appropriate easy_groups
	#easy_groups is what our cas server will use to signal authorization level to the main apps
	def self.update_all_easy_groups
		User.all.each do |u|
			u.update_easy_groups
		end
	end
	
	def update_easy_groups
		new_easy_groups = []
		self.groups.each do |g|
			new_easy_groups << g.name
		end
		self.update_attributes(:easy_groups => new_easy_groups.join(", "))
	end
	
	def full_name
		first_name + " " + last_name
	end
	
	def deliver_password_reset_instructions!  
		reset_perishable_token!  
		Notifier.password_reset_instructions(self).deliver
	end 
			
end
