require "bundler/capistrano"
set :bundle_flags, "--no-deployment --without test development"

set :default_environment, {
  'PATH' => '/usr/local/ruby-2.0.0-p247/bin:$PATH'
}

set :application, "sample_app"
set :scm, :git
set :repository,  "https://github.com/Tacahilo/sample_app.git"
set :branch, 'master'
set :deploy_to, "/var/www/rails"
set :shared_paths, ['config/database.yml', 'log']
set :rails_env, "production"

set :user, "okkun"
set :user_group, "appuser"
ssh_options[:keys] = "~/.ssh/maglica"
set :use_sudo, false

role :app, "app001.okkun.pb", "app002.okkun.pb"
role :web, "app001.okkun.pb", "app002.okkun.pb"
role :db,  "app001.okkun.pb", "app002.okkun.pb", :primary => true

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

namespace :deploy do
  desc 'Start unicorn'
  task :start, :roles => :app do
    run "sudo /etc/init.d/unicorn start"
  end

  desc 'Stop unicorn'
  task :stop, :roles => :app do
    run "sudo /etc/init.d/unicorn stop"
  end

  desc 'Upgrade unicorn'
  task :upgrade, :roles => :app do
    run "sudo /etc/init.d/unicorn upgrade"
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
