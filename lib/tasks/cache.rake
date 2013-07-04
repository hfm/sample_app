require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :cache
  desc 'Clear memcache'
  tast :clear => :environment do
    Rails.cache.clear
  end
end
