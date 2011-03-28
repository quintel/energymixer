class MixerMailer < ActionMailer::Base
  layout 'mailer'
  default :from => "no-reply@quintel.com"
  default_url_options[:host] = APP_CONFIG["hostname"]

  def thankyou(scenario)
    @scenario = scenario
    mail :to => scenario.email, :subject => "Your scenario"
  end
end
