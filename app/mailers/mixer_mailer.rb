class MixerMailer < ActionMailer::Base
  layout 'mailer'
  default :from => "no-reply@quintel.com"
  default_url_options[:host] = APP_CONFIG["hostname"]
  include ScenariosHelper

  def thankyou(scenario)
    @scenario = scenario
    @etm_scenario_url = scenario_in_etm_url(@scenario)
    mail :to => scenario.email, :subject => "Jouw Energy Mix"
  end
end
