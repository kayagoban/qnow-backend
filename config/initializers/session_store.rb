#ActionController::Base.session_store = :redis_store,
#  servers: %w(redis://localhost:6379/0/session),
#  expire_after: 90.minutes,
#  key: '_my_application_session',
#  threadsafe: false,
#  signed: true,
#  secure: true
Rails.application.config.session_store :redis_store,
  servers: ["redis://localhost:6379/0/session"],
  expire_after: 90.minutes,
  key: "_#{Rails.application.class.parent_name.downcase}_session",
  threadsafe: true,
  signed: true,
  secure: true
#Rails.application.config.session_store :cookie_store, key: '_your_app_session'
