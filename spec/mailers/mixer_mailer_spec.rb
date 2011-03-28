require "spec_helper"

describe MixerMailer do
  describe "thankyou" do
    let(:scenario) { Factory :scenario }
    let(:mail) { MixerMailer.thankyou(scenario) }

    it "renders the headers" do
      mail.subject.should eq("Your scenario")
    end

    it "renders the body with a link to the scenario" do
      mail.body.encoded.should match(scenario_path(scenario))
    end
  end

end
