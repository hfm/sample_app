set :application, "sample_app"

require 'capistrano_colors'
require "bundler/capistrano"
set :bundle_flags, "--no-deployment --without test development"

set :scm, :git
set :repository,  "https://github.com/Tacahilo/sample_app.git"
set :branch, 'master'
set :deploy_to, "/var/www/rails"
set :shared_paths, ['config/database.yml', 'log']
set :rails_env, "production"

set :user, "okkun"
ssh_options[:keys] = "~/.ssh/maglica"
set :use_sudo, false

role :app, "app002.okkun.pb"
role :web, "app002.okkun.pb"
role :db,  "app002.okkun.pb", :primary => true

task :env do
  run 'env'
end

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

namespace :deploy do
  desc 'Restart unicorn'
  task :unicorn_restart, :roles => :web do
    run "/etc/init.d/unicorn restart"
  end

  desc 'Clear cache'
  task :clear_dalli_cache do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake cache:clear"
  end
end

before :deploy, "deploy:setup"
after :deploy, "deploy:migrate"
after :deploy, "assets:precompile"
after :deploy, "deploy:restart"
after :deploy, "deploy:cleanup"
after :deploy, "deploy:unicorn_restart"
after :deploy, "deploy:clear_dalli_cache"
