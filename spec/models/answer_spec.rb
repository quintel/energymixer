require 'spec_helper'

describe Answer do
  it { should validate_presence_of :answer }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }
  
  describe "conflicting questions" do
    it "should handle question ids" do
      a = Answer.new
      a.conflicting_question_ids = [1,2,3]
      a.conflicting_questions.should == "1,2,3"
      
      a.conflicting_questions = "1,2"
      a.conflicting_question_ids.should == [1,2]
    end
  end
end

