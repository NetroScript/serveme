require './config/boot'
require 'puma/capistrano'
require "./config/deploy/logdaemon"

set :stages,            %w(eu na au)
set :default_stage,     "eu"
set :application,       "serveme"
set :deploy_to,         "/var/www/serveme"
set :use_sudo,          false
set :main_server,       "wilhelm.fakkelbrigade.eu"
set :keep_releases,     10
set :deploy_via,        :remote_cache
set :repository,        "https://github.com/Arie/serveme.git"
set :branch,            'csgo'
set :scm,               :git
set :copy_compression,  :gzip
set :use_sudo,          false
set :user,              'arie'
set :rvm_ruby_string,   '2.3.0'
set :rvm_type,          :user
set :stage,             'production'
set :maintenance_template_path, 'app/views/pages/maintenance.html.erb'
set :deploy_to,         "/var/www/serveme"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy:finalize_update', 'app:symlink'
after 'deploy',                 'deploy:cleanup'
after "deploy:stop",            "logdaemon:stop"
after "deploy:start",           "logdaemon:start"
after "deploy:restart",         "logdaemon:restart"

namespace :app do
  desc "makes a symbolic link to the shared files"
  task :symlink, :roles => [:web, :app] do
    run "ln -sf #{shared_path}/config/puma/production.rb #{release_path}/config/puma/production.rb"
    run "ln -sf #{shared_path}/config/initializers/steam_api_key.rb #{release_path}/config/initializers/steam_api_key.rb"
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -sf #{shared_path}/config/paypal.yml #{release_path}/config/paypal.yml"
    run "ln -sf #{shared_path}/public/uploads #{release_path}/public/uploads"
    run "ln -sf #{shared_path}/server_logs #{release_path}/server_logs"
    run "ln -sf #{shared_path}/config/initializers/raven.rb #{release_path}/config/initializers/raven.rb"
    run "ln -sf #{shared_path}/config/initializers/maps_dir.rb #{release_path}/config/initializers/maps_dir.rb"
    run "ln -sf #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -sf #{shared_path}/config/initializers/locale.rb #{release_path}/config/initializers/locale.rb"
    run "ln -sf #{shared_path}/config/initializers/devise.rb #{release_path}/config/initializers/devise.rb"
    run "ln -sf #{shared_path}/config/initializers/site_url.rb #{release_path}/config/initializers/site_url.rb"
    run "ln -sf #{shared_path}/doc/GeoLiteCity.dat #{release_path}/doc/GeoLiteCity.dat"
    run "ln -sf #{shared_path}/config/cacert.pem #{release_path}/config/cacert.pem"
  end

end



namespace :puma do
    desc 'Restart puma'
    task :restart, :roles => lambda { puma_role }, :on_no_matching_servers => :continue do
      phased_restart
    end
end

def execute_rake(task_name, path = release_path)
  run "cd #{path} && bundle exec rake RAILS_ENV=#{rails_env} #{task_name}", :env => {'RAILS_ENV' => rails_env}
end

after "deploy", "deploy:cleanup"

require 'rvm/capistrano'
