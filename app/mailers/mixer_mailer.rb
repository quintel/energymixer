class MixerMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'no-reply@quintel.com'

  include ScenariosHelper

  def thankyou(scenario)
    @scenario  = scenario
    @partition = Partition.named(@scenario.question_set.name)

    default_url_options[:host] = @partition.host

    @etm_scenario_url = scenario_in_etm_url(@scenario)

    mail to: scenario.email, subject: 'Jouw Energy Mix'
  end
end
