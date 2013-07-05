rails_root = '/var/www/rails/current' 
working_directory rails_root
worker_processes 4

listen rails_root + '/run/unicorn.sock', :backlog => 64
timeout 30

pid rails_root + "/tmp/pids/unicorn.pid"

stderr_path rails_root + "/log/unicorn.stderr.log"
stdout_path rails_root + "/log/unicorn.stdout.log"

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

   old_pid = "#{server.config[:pid]}.oldbin"
   if old_pid != server.pid
     begin
       sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
       Process.kill(sig, File.read(old_pid).to_i)
     rescue Errno::ENOENT, Errno::ESRCH
     end
   end
end
 
after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(ActiveSupport::Cache::Dallistore) and Rails.cache.is_a?(ActiveSupport::Cache::Dallistore)
    Rails.cache.reset

    ObjectSpace.each_object(ActionDispache::Session::DalliStore) { |obj| obj.reset }
  end
end
