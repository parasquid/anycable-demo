# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "app"
set :repo_url, "https://github.com/parasquid/anycable-demo"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/app"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  keys: %w('~/.ssh/id_rsa.pub'),
}

namespace :deploy do
  task :restart do
    on roles(:web) do
      execute "sudo service nginx restart"
    end
  end

  after :deploy, "deploy:restart"
end

namespace :db do
  desc "seeds the database"
  task :seed do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rails, "db:seed"
        end
      end
    end
  end

  desc "resets the database (also runs the seed file)"
  task :reset do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "sudo service nginx stop"
          execute :rails, "db:reset"
          execute "sudo service nginx restart"
        end
      end
    end
  end
end

namespace :rails do
  task :log_tail do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end