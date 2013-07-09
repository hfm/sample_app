require 'capistrano_colors'
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :stages, %w(app db)
set :default_stage, "app"

namespace :puppet do
  desc 'puppet apply to app001'
  task :app001 do
    puppet_apply('app')
  end

  desc 'puppet apply to app002'
  task :app002 do
    puppet_apply('app_with_session')
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
