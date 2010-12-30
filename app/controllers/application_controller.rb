class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :require_user
  helper_method :allowed_to_view?, :allowed_to_edit?
  # before_filter :raise_error

  def allowed_to_view?
  	if session[:cas_extra_attributes] && session[:cas_extra_attributes][:easy_groups].include?("user_management")
  		return true
  	end
  	return false
  end
  
  def allowed_to_edit?
  	if session[:cas_extra_attributes] && session[:cas_extra_attributes][:easy_groups].include? "user_management"
  		return true
  	end
  	return false
  end
  
  def require_user
  	unless allowed_to_view? && allowed_to_edit?
  		raise "User not allowed!"
  	end
  end
  
  def raise_error
  	raise.error
  end
end
