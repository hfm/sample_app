set :user, "okkun"
set :user_group, "appuser"
ssh_options[:keys] = "~/.ssh/maglica"
set :use_sudo, false

role :app, "db001.okkun.pb"
role :web, "db001.okkun.pb"
role :db,  "db001.okkun.pb", :primary => true
