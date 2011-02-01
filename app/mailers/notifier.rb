class Notifier < ActionMailer::Base
  default :from => APP_CONFIG["password_resets_from_address"]
  default_url_options[:host] = APP_CONFIG["cas_user_management_url"]  
  
  def password_reset_instructions(user)  
	subject       "Password Reset Instructions"  
	recipients    user.email  
	sent_on       Time.now  
	body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end 
end
