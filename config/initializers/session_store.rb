# Be sure to restart your server when you modify this file.

SampleApp::Application.config.session_store :cookie_store, key: '_sample_app_session'

after_fork do |server, worker|
  if defined?(ActiveSupport::Cache::Dallistore) and Rails.cache.is_a?(ActiveSupport::Cache::Dallistore)
    Rails.cache.reset

    ObjectSpace.each_object(ActionDispache::Session::DalliStore) { |obj| obj.reset }
  end
end

