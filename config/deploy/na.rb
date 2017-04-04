set :main_server,       "csna.serveme.tf"
set :user,              'arie'
set :puma_threads,      [0,4]
set :puma_workers,      2
set :sidekiq_processes,  1

server "direct.na.serveme.tf", user: "arie", roles: ["web", "app", "db"]

namespace :app do
  desc "symlinks the tragicservers login information"
  task :symlink_tragicservers do
    on roles(:web, :app) do
      execute "ln -sf #{shared_path}/config/initializers/tragicservers.rb #{release_path}/config/initializers/tragicservers.rb"
    end
  end
end

after "deploy:symlink:linked_files", "app:symlink_tragicservers"
