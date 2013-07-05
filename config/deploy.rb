require 'capistrano_colors'
require "bundler/capistrano"
set :bundle_flags, "--no-deployment --without test development"
load 'deploy/assets'

set :application, "sample_app"
set :scm, :git
set :repository,  "https://github.com/Tacahilo/sample_app.git"
set :branch, 'master'
set :deploy_to, "/var/www/rails"
set :shared_paths, ['config/database.yml', 'log']
set :rails_env, "production"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

set :user, "okkun"
set :user_group, "appuser"
ssh_options[:keys] = "~/.ssh/maglica"
set :use_sudo, false

role :app, "192.168.46.90"
role :web, "192.168.46.90"
role :db,  "192.168.46.90", :primary => true

task :env do
  run 'env'
end

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

namespace :deploy do
  desc 'Start unicorn'
  task :start, :roles => :app do
    run "/etc/init.d/unicorn start"
  end

  desc 'Restart unicorn'
  task :restart, :roles => :app do
    run "/etc/init.d/unicorn restart"
  end

  desc 'Clear cache'
  task :clear_dalli_cache do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake cache:clear"
  end
end
