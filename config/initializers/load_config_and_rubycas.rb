require 'casclient'
require 'casclient/frameworks/rails/filter'

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => APP_CONFIG["cas_base_url"]
  )
  
ActionMailer::Base.smtp_settings = {
  :address => APP_CONFIG["email_smtp_address"],
  :port => APP_CONFIG["email_port"],
  :domain => APP_CONFIG["email_domain"],
  :authentication => "plain",
  :user_name => APP_CONFIG["email_username"],
  :password => APP_CONFIG["email_password"]
}