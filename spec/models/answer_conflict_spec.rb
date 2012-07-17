require 'spec_helper'

describe AnswerConflict do
  it { should validate_presence_of :answer_id }
  it { should validate_presence_of :other_answer_id }
  
  it "shouldn't create duplicate records" do
    c = create(:answer_conflict)
    d = AnswerConflict.new :answer_id => c.answer_id, :other_answer_id => c.other_answer_id
    d.should_not be_valid
  end
  
  it "shouldn't create duplicate records in the opposite direction" do
    c = create(:answer_conflict)
    d = AnswerConflict.new(:answer_id => c.other_answer_id, :other_answer_id => c.answer_id)
    d.should_not be_valid
  end
end
