class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_cas
  before_filter :require_user
  helper_method :allowed_to_view?, :allowed_to_edit?, :username, :require_no_user
  # before_filter :raise_error

    def allowed_to_view?
  	return true if all_groups && (all_groups & groups_allowed_to_view)
  end
  
  def allowed_to_edit?
  	return true if all_groups && (all_groups & groups_allowed_to_edit)
  end
  
  def require_user
  	unless allowed_to_view? && allowed_to_edit?
  		raise "User not allowed!"
  	end
  end
  
  private
  
  ################################BEGIN Who can do what?########################################
  def groups_allowed_to_view
  	["user_management", "sudo"]
  end
  
  def groups_allowed_to_edit
  	["user_management", "sudo"]
  end
  
  def all_groups
  	return @all_groups if defined?(@all_groups)
  	if session[:cas_extra_attributes] && session[:cas_extra_attributes][:easy_groups]
  		@all_groups = session[:cas_extra_attributes][:easy_groups].split(", ")
  	end
  end
  
  def require_no_user
  	if username
  		raise "Sorry, you must be logged out to view this page!"
  	else
  		true
  	end
  end
  
  def username
  	return @username if defined?(@username)
  	if session[:cas_user]
  		@username = session[:cas_user]
  	end
  end
  
  def skip_cas
  	#we use this to decide when we should skip cas login on a page.  for example, on the password resets we can just set this to true.  This is a workaround for the skip_before_filter issue with rails 3
  		false
  end
  #############################END who can do what?#####################################
end
