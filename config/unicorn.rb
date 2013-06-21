rails_root = "/var/www/sample_app" 

worker_processes 4

working_directory rails_root # available in 0.94.0+

listen rails_root + "/tmp/sockets/unicorn.sock", :backlog => 64
#"listen 3000

timeout 30

pid rails_root + "/unicorn.pid"

stderr_path rails_root + "/log/unicorn.stderr.log"
stdout_path rails_root + "/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
