class Notifier < ActionMailer::Base
  default :from => APP_CONFIG["email_from"]
  default_url_options[:host] = APP_CONFIG["cas_user_management_url"]  
  
  def password_reset_instructions(user)  
	subject       "Password Reset Instructions"  
	from		  APP_CONFIG["email_from"]
	recipients    user.email  
	sent_on       Time.now  
	body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end 
end
