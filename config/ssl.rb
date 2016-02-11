Rails.application.configure do
  config.force_ssl = true if RAILS_ENV != 'test'
end