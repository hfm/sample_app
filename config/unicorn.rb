rails_root = "/var/www/rails/current" 

worker_processes 4

working_directory rails_root

listen rails_root + "/tmp/sockets/unicorn.sock", :backlog => 64

timeout 30

pid rails_root + "/tmp/pids/unicorn.pid"

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

  if defined?(ActiveSupport::Cache::Dallistore) and Rails.cache.is_a?(ActiveSupport::Cache::Dallistore)
    Rails.cache.reset

    ObjectSpace.each_object(ActionDispache::Session::DalliStore) { |obj| obj.reset }
  end
end
