require 'spec_helper'

describe Input do
  it { should validate_presence_of :slider_id }
  
  it "should have a slider id assigned" do
    i = Input.new
    i.key = 'foobar'
    i.slider_id.should be_nil
    i.should_not be_valid
    
    real_key = Input::KEYS.first
    i.key = real_key[1]
    i.slider_id.should == real_key[0]
    i.should be_valid
  end
end

