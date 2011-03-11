require 'spec_helper'

describe Question do
  it { should validate_presence_of :question }
  it { should have_many :answers }
  
  describe "#number" do
    it "should have number 1 when ordering is 0" do
      question = Factory.create(:question, :ordering => 0)
      question.number.should eql(1)
    end
    it "should have number 2 when ordering is 1" do
      question = Factory.create(:question, :ordering => 1)
      question.number.should eql(2)
    end
  end
  
end

