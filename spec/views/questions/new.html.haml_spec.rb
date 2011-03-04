require 'spec_helper'

describe "questions/new.html.haml" do
  before(:each) do
    assign(:question, stub_model(Question,
      :question => "MyString",
      :order => 1
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path, :method => "post" do
      assert_select "input#question_question", :name => "question[question]"
      assert_select "input#question_order", :name => "question[order]"
    end
  end
end
