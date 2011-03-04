require 'spec_helper'

describe "inputs/new.html.haml" do
  before(:each) do
    assign(:input, stub_model(Input,
      :key => "MyString",
      :value => "9.99",
      :answr_id => 1
    ).as_new_record)
  end

  it "renders new input form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => inputs_path, :method => "post" do
      assert_select "input#input_key", :name => "input[key]"
      assert_select "input#input_value", :name => "input[value]"
      assert_select "input#input_answr_id", :name => "input[answr_id]"
    end
  end
end
