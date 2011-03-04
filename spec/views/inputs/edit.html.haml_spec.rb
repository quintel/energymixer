require 'spec_helper'

describe "inputs/edit.html.haml" do
  before(:each) do
    @input = assign(:input, stub_model(Input,
      :key => "MyString",
      :value => "9.99",
      :answr_id => 1
    ))
  end

  it "renders the edit input form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => inputs_path(@input), :method => "post" do
      assert_select "input#input_key", :name => "input[key]"
      assert_select "input#input_value", :name => "input[value]"
      assert_select "input#input_answr_id", :name => "input[answr_id]"
    end
  end
end
