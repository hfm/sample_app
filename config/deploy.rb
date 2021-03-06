require 'capistrano_colors'
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :stages, %w(app db proxy)
set :default_stage, "app"

namespace :puppet do
  desc 'puppet apply to app'
  task :app001 do
    puppet_apply('app')
  end

  desc 'puppet apply to proxy'
  task :proxy do
    puppet_apply('proxy')
  end

  desc 'puppet apply to db'
  task :db do
    puppet_apply('db')
  end
end

def puppet_apply(manifests)
  puppet_path = '/home/hfm/sampleapp_spec_puppet/puppet.d/'
  run("cd #{puppet_path}; sudo puppet apply manifests/#{manifests}.pp --modulepath=modules:roles")
end
