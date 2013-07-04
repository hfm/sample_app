# Be sure to restart your server when you modify this file.

SampleApp::Application.config.session_store :cookie_store, key: '_sample_app_session'

Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 20.minutes
