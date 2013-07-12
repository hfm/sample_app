set :user, "okkun"
set :user_group, "appuser"
ssh_options[:keys] = "~/.ssh/maglica"
set :use_sudo, false

role :app, "app.okkun.pb"
role :web, "app.okkun.pb"
role :db,  "app.okkun.pb", :primary => true
