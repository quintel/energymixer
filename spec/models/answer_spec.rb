require 'spec_helper'

describe Answer do
  it { should validate_presence_of :answer }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }
  
  describe "conflicting answers" do
    it "should store a conflict on assignment" do
      a = Factory :answer, :question => Factory(:question)
      b = Factory :answer, :question => Factory(:question)
      a.conflicting_answer_ids.should be_empty
      a.conflicting_answer_ids = [b.id]
      a.save
      a.reload.conflicting_answers.size.should == 1
    end    
  end
end

