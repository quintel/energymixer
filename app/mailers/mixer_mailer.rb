class MixerMailer < ActionMailer::Base
  default :from => "no-reply@example.com"

  def thankyou(scenario)
    mail :to => scenario.email, :subject => "Your scenario"
  end
end
