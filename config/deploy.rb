set :application, "sportsleisure.com"
set :directory, "users.mazondo.com"
set :repository,  "git@github.com:mazondo/cas-user-management.git"
set :user, "adeployeruser"
set :bundle_cmd, "/opt/ruby-enterprise-1.8.7-20090928/bin/bundle"
#remove --deployment so that we don't include gemfile.lock because of windows -> linux issues
set :bundle_flags, "--quiet"

# needed for sudo, can remove runner later once the bottom script is confirmed to work
# set :runner, "adeployeruser"
set :port, 40000

default_run_options[:pty] = true
set :scm, "git"
set :scm_passphrase, ""

ssh_options[:forward_agent] = true
set :branch, "master"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{directory}"



# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, application
role :web, application
role :db, application , :primary => true

# other options
ssh_options[:keys] = %w(/home/adeployeruser/.ssh/id_rsa) # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp* script/process script/process/*"
set :use_sudo, false
set :rake, "/opt/ruby-enterprise-1.8.7-20090928/bin/rake"

task :after_update_code, :roles => [:app, :db] do
  # fix permissions
  run "chmod -R +x #{release_path}/script/*"
  run "chown -R #{user} #{release_path}/script/*"
  run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  run "ln -nfs #{shared_path}/config/database.yml "+
              "#{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/initializers/rubycas.rb "+
              "#{release_path}/config/initializers/rubycas.rb"
end

namespace :deploy do
  desc "Restart passenger."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Initial setup of the shared_path."
  task :setup_shared do
    run "mkdir -p #{shared_path}/config #{shared_path}/assets"
  end

  desc "Gets the shared_path ready for use with the release."
  task :prepare_shared do
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/config/database.yml "+
              "#{release_path}/config/database.yml"
  end
end
# after 'deploy:setup', 'deploy:setup_shared'
# before 'deploy:finalize_update', 'deploy:prepare_shared'

require "bundler/capistrano"
