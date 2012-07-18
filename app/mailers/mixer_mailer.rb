class MixerMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'no-reply@quintel.com'

  include ScenariosHelper

  def thankyou(scenario)
    @scenario  = scenario
    @partition = Partition.named(@scenario.question_set.name)

    default_url_options[:host] = @partition.host

    @etm_scenario_url = scenario_in_etm_url(@scenario)

    # Enable theming by adding custom views to app/views/{partition.name}.
    prepend_view_path(Rails.root.join('app', 'views', @partition.name))

    mail to: scenario.email, subject: 'Jouw Energy Mix'
  end
end
