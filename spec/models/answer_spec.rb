require 'spec_helper'

describe Answer do
  it { should validate_presence_of :answer }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }
  
  describe "conflicting answers" do
  end
end

