if Rails.env.development?
  # for mailtrap
  ActionMailer::Base.smtp_settings = {
    :address => 'localhost',
    :port    => 2525
  }
end

if APP_NAME
  ActionMailer::Base.prepend_view_path("app/views/" + APP_NAME)
end


ActionMailer::Base.smtp_settings = {
  # Postfix fails on production without this
  :enable_starttls_auto => false
}
