require 'casclient'
require 'casclient/frameworks/rails/filter'

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => APP_CONFIG["cas_base_url"]
  )