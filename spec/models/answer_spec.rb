require 'spec_helper'

describe Answer do
  it { should validate_presence_of :text_nl }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }
  
  describe "conflicting answers" do
    it "should store a conflict on assignment" do
      a = create :answer, :question => create(:question)
      b = create :answer, :question => create(:question)
      a.conflicting_answer_ids.should be_empty
      a.conflicting_answer_ids = [b.id]
      a.save
      a.reload.conflicting_answers.size.should == 1
    end    
  end
end

