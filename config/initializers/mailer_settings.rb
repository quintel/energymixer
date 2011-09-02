if Rails.env.development?
  # for mailtrap
  ActionMailer::Base.smtp_settings = {
    :address => 'localhost',
    :port    => 2525
  }
end

# TODO: update as needed
if APP_CONFIG['app_name']
  ActionMailer::Base.template_root = "app/views/" + APP_CONFIG["app_name"]
end