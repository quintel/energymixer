require "spec_helper"

describe MixerMailer do
  describe "thankyou" do
    before do
      @scenario = Factory :user_scenario
    end
    
    let(:mail) { MixerMailer.thankyou(@scenario) }

    it "renders the headers" do
      mail.subject.should eq("Your scenario")
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
