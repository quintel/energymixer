require "spec_helper"

describe MixerMailer do
  describe "thankyou" do
    partitions = %w( mixer gasmixer )
    languages  = %w( en nl de )

    partitions.each do |partition|
      languages.each do |language|
        context "with partition:#{partition} and locale:#{language}" do

          before { I18n.locale = language.to_sym }
          after  { I18n.locale = :en }

          include ScenariosHelper

          let(:question_set) { create :question_set, name: partition }
          let(:scenario)     { create :scenario, question_set: question_set,
                                                 etm_scenario_id: 1337 }
          let(:mail)         { MixerMailer.thankyou(scenario) }

          it 'renders the headers' do
            if language == 'de'
              mail.subject.should match(/Energiemix/)
            else
              mail.subject.should match(/Energy Mix/)
            end
          end

          it 'renders the body with a link to the scenario' do
            mail.body.parts.each do |part|
              part.to_s.should include(scenario_path(scenario))
              part.to_s.should include(Partition.named(partition).host)
            end
          end

          it 'should contain the application name' do
            mail.body.parts.each do |part|
              part.to_s.should include(" #{ I18n.t(partition) } ")
            end
          end

          it 'should contain the application name in the HTML title' do
            html = mail.body.parts.last.to_s
            html.should include("<title>#{ I18n.t(partition) }</title>")
          end

          it 'should link to the ETM' do
            mail.body.parts.each do |part|
              url = scenario_in_etm_url(scenario, language)
              url.should include('locale=nl') if language == 'de'

              part.to_s.should include(url)
            end
          end

        end # with partition:... and locale:...
      end # en, nl, de
    end # mixer, gasmixer
  end # thankyou
end
