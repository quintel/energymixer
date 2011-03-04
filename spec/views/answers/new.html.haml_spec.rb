require 'spec_helper'

describe "answers/new.html.haml" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :answer => "MyString",
      :order => 1,
      :question_id => 1
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => answers_path, :method => "post" do
      assert_select "input#answer_answer", :name => "answer[answer]"
      assert_select "input#answer_order", :name => "answer[order]"
      assert_select "input#answer_question_id", :name => "answer[question_id]"
    end
  end
end
