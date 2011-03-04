require 'spec_helper'

describe "answers/index.html.haml" do
  before(:each) do
    assign(:answers, [
      stub_model(Answer,
        :answer => "Answer",
        :order => 1,
        :question_id => 1
      ),
      stub_model(Answer,
        :answer => "Answer",
        :order => 1,
        :question_id => 1
      )
    ])
  end

  it "renders a list of answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Answer".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
