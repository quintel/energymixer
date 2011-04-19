require 'spec_helper'

describe AnswerConflict do
  it { should validate_presence_of :answer_id }
  it { should validate_presence_of :other_answer_id }
  
  it "shouldn't create duplicate records" do
    c = Factory :answer_conflict
    d = c.clone
    d.should_not be_valid
  end
end
