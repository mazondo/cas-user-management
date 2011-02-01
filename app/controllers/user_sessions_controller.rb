class UserSessionsController < ApplicationController
	
	def logout
		#built in rubycas-client logout function.  removes session data and redirects to CAS logout page
		CASClient::Frameworks::Rails::Filter.logout(self)
	end
end
