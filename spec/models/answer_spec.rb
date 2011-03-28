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
    
    it "should remove an id when the answer is deleted" do
      a1 = Factory :answer
      a2 = Factory :answer
      a3 = Factory :answer
      a1.conflicting_answer_ids = [a2.id, a3.id]
      a1.save
      a1.conflicting_answer_ids_string.should == "#{a2.id},#{a3.id}"
      
      a2.destroy
      a1.reload.conflicting_answer_ids.should == [a3.id]
    end
  end
end

