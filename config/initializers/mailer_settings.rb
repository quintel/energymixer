if Rails.env.development?
  # for mailtrap
  ActionMailer::Base.smtp_settings = {
    :address => 'localhost',
    :port    => 2525
  }
end

# Postfix fails on production without this.
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false
