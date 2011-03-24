require 'spec_helper'

describe Answer do
  it { should validate_presence_of :answer }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }
  
  describe "conflicting answers" do
    it "should handle answer ids" do
      a = Answer.new
      a.conflicting_answer_ids = [1,2,3]
      a.conflicting_answer_ids_string.should == "1,2,3"
      
      a.conflicting_answer_ids_string = "1,2"
      a.conflicting_answer_ids.should == [1,2]
    end
  end
end

