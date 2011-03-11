require 'spec_helper'

describe Answer do
  it { should validate_presence_of :answer }
  it { should have_many(:inputs) }
  it { should belong_to(:question) }

  describe "#letter" do
    %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].each_with_index do |letter, index|    
      it "should say #{letter} when the answer is number #{index} of a question" do
        answer = Factory.create(:answer, :ordering => index)
        answer.letter.should eql(letter)
      end
    end
  end

end

