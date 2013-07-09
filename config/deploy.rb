require 'capistrano_colors'
require 'capistrano/ext/multistage'
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

role :app, "app001.okkun.pb"
role :web, "app001.okkun.pb"
role :db,  "app001.okkun.pb", :primary => true

namespace :deploy do
  desc 'Start unicorn'
  task :start, :roles => :app do
    run "sudo /etc/init.d/unicorn start"
  end

  desc 'Restart unicorn'
  task :restart, :roles => :app do
    run "sudo /etc/init.d/unicorn restart"
  end

  desc 'Clear cache'
  task :clear_dalli_cache do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake cache:clear"
  end
end

namespace :puppet do
  desc 'puppet apply to app001'
  task :app001 do
    puppet_apply('app')
  end

  desc 'puppet apply to app002'
  task :app002 do
    puppet_apply('app')
  end

  desc 'puppet apply to db001'
  task :db001 do
    puppet_apply('db')
  end
end

def puppet_apply(manifests)
  puppet_path = '/home/hfm/sampleapp_spec_puppet/puppet.d/'
  run("cd #{puppet_path}; sudo puppet apply manifests/#{manifests}.pp --modulepath=modules:roles")
end
