require 'spec_helper'

describe "answers/show.html.haml" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :answer => "Answer",
      :order => 1,
      :question_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Answer/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
